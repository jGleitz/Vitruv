package tools.vitruv.framework.domains

import java.util.Collections
import java.util.List
import org.eclipse.emf.common.notify.Notifier
import org.eclipse.emf.common.util.BasicMonitor
import org.eclipse.emf.compare.Diff
import org.eclipse.emf.compare.EMFCompare
import org.eclipse.emf.compare.merge.BatchMerger
import org.eclipse.emf.compare.merge.IMerger
import org.eclipse.emf.compare.scope.DefaultComparisonScope
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import tools.vitruv.framework.change.description.TransactionalChange
import tools.vitruv.framework.change.description.VitruviusChangeFactory
import tools.vitruv.framework.change.recording.AtomicEmfChangeRecorder
import tools.vitruv.framework.uuid.UuidGeneratorAndResolver
import tools.vitruv.framework.uuid.UuidGeneratorAndResolverImpl

/**
 * This default strategy for diff based state changes uses EMFCompare to resolve a 
 * diff to a sequence of individual changes.
 * @author Timur Saglam
 */
class DefaultStateChangePropagationStrategy implements StateChangePropagationStrategy {
	val VitruviusChangeFactory changeFactory

	/**
	 * Creates the strategy.
	 */
	new() {
		changeFactory = VitruviusChangeFactory.instance
	}

	override getChangeSequences(Resource newState, Resource currentState, UuidGeneratorAndResolver resolver) {
		return resolveChangeSequences(newState, currentState, resolver)
	}

	override getChangeSequences(EObject newState, EObject currentState, UuidGeneratorAndResolver resolver) {
		return resolveChangeSequences(newState, currentState, resolver)
	}

	/*
	 * TODO TS Try first: create new resource set and create resource. copy content.
	 * OR compare root object instead of resource
	 * OR use orignal and revert
	 */
	def private resolveChangeSequences(Notifier newState, Notifier currentState, UuidGeneratorAndResolver resolver) {
		if (resolver === null) {
			throw new IllegalArgumentException("UUID generator and resolver cannot be null!")
		} else if (newState === null || currentState === null) {
			return changeFactory.createCompositeChange(Collections.emptyList)
		}
		// Setup resolver and copy state:
		val uuidGeneratorAndResolver = new UuidGeneratorAndResolverImpl(resolver, resolver.resourceSet, true)
		val currentStateCopy = currentState.copy
		// Create change sequences:
		val diffs = compareStates(newState, currentStateCopy)
		val vitruvDiffs = replayChanges(diffs, currentStateCopy, uuidGeneratorAndResolver)
		return changeFactory.createCompositeChange(vitruvDiffs)
	}

	/**
	 * Compares states using EMFCompare and returns a list of all differences.
	 */
	private def List<Diff> compareStates(Notifier newState, Notifier currentState) {
		var scope = new DefaultComparisonScope(newState, currentState, null)
		var comparison = EMFCompare.builder().build().compare(scope)
		return comparison.getDifferences()
	}

	/**
	 * Replays a list of of EMFCompare differences and records the changes to receive Vitruv change sequences. 
	 */
	private def List<TransactionalChange> replayChanges(List<Diff> changesToReplay, Notifier currentState, UuidGeneratorAndResolverImpl resolver) {
		// Setup recorder:
		val changeRecorder = new AtomicEmfChangeRecorder(resolver)
		changeRecorder.addToRecording(currentState)
		changeRecorder.beginRecording()
		// replay the EMF compare diffs:
		val mergerRegistry = IMerger.RegistryImpl.createStandaloneInstance()
		val merger = new BatchMerger(mergerRegistry)
		merger.copyAllLeftToRight(changesToReplay, new BasicMonitor)
		// Finish recording:
		changeRecorder.endRecording()
		return changeRecorder.changes
	}

	/**
	 * Creates a new resource set, creates a resource and copies the content of the orignal resource.
	 */
	private def dispatch Resource copy(Resource resource) {
		val resourceSet = new ResourceSetImpl
		val copy = resourceSet.createResource(resource.URI)
		copy.contents.addAll(EcoreUtil.copyAll(resource.contents))
		return copy
	}

	private def dispatch EObject copy(EObject object) {
		return EcoreUtil.copy(object)
	}
}
