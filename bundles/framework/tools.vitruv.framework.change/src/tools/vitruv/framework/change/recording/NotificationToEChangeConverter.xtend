package tools.vitruv.framework.change.recording

import java.util.List
import org.eclipse.emf.ecore.EObject
import tools.vitruv.framework.change.echange.EChange
import tools.vitruv.framework.change.echange.feature.attribute.AttributeFactory
import tools.vitruv.framework.change.echange.TypeInferringAtomicEChangeFactory
import static extension tools.vitruv.framework.change.preparation.EMFModelChangeTransformationUtil.*
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import tools.vitruv.framework.change.echange.eobject.EObjectAddedEChange
import tools.vitruv.framework.change.echange.eobject.EObjectSubtractedEChange
import tools.vitruv.framework.change.echange.EChangeIdManager
import static org.eclipse.emf.common.notify.Notification.*
import static extension edu.kit.ipd.sdq.commons.util.java.lang.IterableUtil.*
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.common.util.URI

/** 
 * Converts an EMF notification to an {@link EChange}.
 * @author Heiko Klare
 */
@FinalFieldsConstructor
final class NotificationToEChangeConverter {
	val EChangeIdManager eChangeIdManager
	extension val TypeInferringAtomicEChangeFactory changeFactory = TypeInferringAtomicEChangeFactory.instance

	def createDeleteChange(EObjectSubtractedEChange<?> change) {
		val deleteChange = createDeleteEObjectChange(change.oldValue).withGeneratedId()
		deleteChange.consequentialRemoveChanges += allSubstractiveChangesForChangeRelevantFeatures(change.oldValue) //
		.mapFixed[withGeneratedId()]
		return deleteChange
	}

	/** 
	 * Converts the given notification to a list of {@link EChange}s.
	 * @param n the notification to convert
	 * @return the  {@link Iterable} of {@link EChange}s
	 */
	def Iterable<? extends EChange> convert(extension NotificationInfo notification) {
		return switch (notification) {
			case isTouch,
			case isTransient,
			case oldValue == newValue:
				emptyList()
			case notification.isAttributeNotification:
				switch (eventType) {
					case SET: handleSetAttribute(notification)
					case UNSET: handleUnsetAttribute(notification)
					case ADD: handleInsertAttribute(notification)
					case ADD_MANY: handleMultiInsertAttribute(notification)
					case REMOVE: handleRemoveAttribute(notification)
					case REMOVE_MANY: handleMultiRemoveAttribute(notification)
					default: emptyList()
				}
			case notification.isReferenceNotification:
				switch (eventType) {
					case SET: handleSetReference(notification)
					case UNSET: handleUnsetReference(notification)
					case ADD: handleInsertReference(notification)
					case ADD_MANY: handleMultiInsertReference(notification)
					case REMOVE: handleRemoveReference(notification)
					case REMOVE_MANY: handleMultiRemoveReference(notification)
					default: emptyList()
				}
			case notifier instanceof Resource:
				switch (getFeatureID(Resource)) {
					case Resource.RESOURCE__CONTENTS:
						switch (eventType) {
							case ADD: handleInsertRootChange(notification)
							case ADD_MANY: handleMultiInsertRootChange(notification)
							case REMOVE: handleRemoveRootChange(notification)
							case REMOVE_MANY: handleMultiRemoveRootChange(notification)
							default: emptyList()
						}
					case Resource.RESOURCE__URI:
						switch (eventType) {
							case SET: handleSetUriChange(notification)
							default: emptyList()
						}
					default:
						emptyList()
				}
			default:
				emptyList()
		}
	//
	// case Notification.MOVE:
	// if (n.isAttributeNotification()) {
	// return handleAttributeMove(n)
	// }
	// return handleReferenceMove(n)
	}

	def private Iterable<? extends EChange> handleSetAttribute(extension NotificationInfo notification) {
		switch (notification) {
			case !attribute.isMany:
				handleReplaceAttribute(notification)
			case oldValue !== null && newValue !== null:
				handleRemoveAttribute(notification) + handleInsertAttribute(notification)
			case newValue !== null:
				handleInsertAttribute(notification)
			case oldValue !== null:
				handleRemoveAttribute(notification)
			default:
				emptyList()
		}
	}

	private def Iterable<? extends EChange> handleSetReference(extension NotificationInfo notification) {
		switch (notification) {
			case !reference.isMany:
				handleReplaceReference(notification)
			case oldValue !== null && newValue !== null:
				handleRemoveReference(notification) + handleInsertReference(notification)
			case newValue !== null:
				handleInsertReference(notification)
			case oldValue !== null:
				handleRemoveReference(notification)
			default:
				emptyList()
		}
	}

	def private Iterable<? extends EChange> handleUnsetAttribute(extension NotificationInfo notification) {
		return if (!attribute.isMany) {
			handleSetAttribute(notification)
		} else {
			List.of(createUnsetFeatureChange(notifierModelElement, attribute).withGeneratedId())
		}
	}

	private def Iterable<? extends EChange> handleUnsetReference(extension NotificationInfo notification) {
		if (!reference.isMany) {
			handleSetReference(notification)
		} else {
			List.of(createUnsetFeatureChange(notifierModelElement, reference).withGeneratedId())
		}
	}

	private def Iterable<? extends EChange> handleReplaceAttribute(extension NotificationInfo notification) {
		val change = AttributeFactory.eINSTANCE.createReplaceSingleValuedEAttribute()
		change.oldValue = oldValue
		change.newValue = newValue
		change.affectedFeature = attribute
		change.affectedEObject = notifierModelElement
		change.isUnset = wasUnset
		return List.of(change.withGeneratedId())
	}

	private def Iterable<? extends EChange> handleReplaceReference(extension NotificationInfo notification) {
		val change = createReplaceSingleReferenceChange(notifierModelElement, reference, oldModelElementValue,
			newModelElementValue)
		change.isUnset = notification.wasUnset
		return change.surroundWithCreateAndFeatureChangesIfNecessary().mapFixed[withGeneratedId()]
	}

	private def handleRemoveAttribute(extension NotificationInfo notification) {
		createRemoveAttributeChange(notifierModelElement, attribute, position, oldValue).withGeneratedId().
			addUnsetChangeIfNecessary(notification)
	}

	private def handleMultiRemoveAttribute(extension NotificationInfo notification) {
		// TODO HK Is that check necessary?
		if (newValue === null) {
			val oldValues = oldValue as List<?>
			oldValues.reverseView.mapFixedIndexed [ index, value |
				val valueIndex = initialIndex + oldValues.size - 1 - index
				createRemoveAttributeChange(notifierModelElement, attribute, valueIndex, value).withGeneratedId()
			].addUnsetChangeIfNecessary(notification)
		} else {
			unsetChangeOrEmpty(notification)
		}
	}

	private def Iterable<? extends EChange> handleRemoveReference(extension NotificationInfo notification) {
		createRemoveReferenceChange(notifierModelElement, reference, oldModelElementValue, position).withGeneratedId().
			addUnsetChangeIfNecessary(notification)
	}

	private def Iterable<? extends EChange> handleMultiRemoveReference(extension NotificationInfo notification) {
		if (newValue === null) {
			val oldValues = oldValue as List<EObject>
			oldValues.reverseView.mapFixedIndexed [ index, value |
				val valueIndex = initialIndex + oldValues.size - 1 - index
				createRemoveReferenceChange(notifierModelElement, reference, value, valueIndex).withGeneratedId()
			].addUnsetChangeIfNecessary(notification)
		} else {
			unsetChangeOrEmpty(notification)
		}
	}

	private def handleInsertAttribute(extension NotificationInfo notification) {
		List.of(createInsertAttributeChange(notifierModelElement, attribute, position, newValue).withGeneratedId())
	}

	private def handleMultiInsertAttribute(extension NotificationInfo notification) {
		(newValue as List<?>).mapFixedIndexed [ index, value |
			createInsertAttributeChange(notifierModelElement, attribute, initialIndex + index, value).withGeneratedId()
		]
	}

	private def Iterable<? extends EChange> handleInsertReference(extension NotificationInfo notification) {
		createInsertReferenceChange(notifierModelElement, reference, newModelElementValue, position).
			surroundWithCreateAndFeatureChangesIfNecessary().mapFixed[withGeneratedId()]
	}

	private def Iterable<? extends EChange> handleMultiInsertReference(extension NotificationInfo notification) {
		(newValue as List<EObject>).flatMapFixedIndexed [ index, value |
			createInsertReferenceChange(notifierModelElement, reference, value, initialIndex + index).
				surroundWithCreateAndFeatureChangesIfNecessary().mapFixed[withGeneratedId()]
		]
	}

	private def handleInsertRootChange(extension NotificationInfo notification) {
		createInsertRootChange(newModelElementValue, notifierResource, position).
			surroundWithCreateAndFeatureChangesIfNecessary().mapFixed[withGeneratedId()]
	}

	private def handleMultiInsertRootChange(extension NotificationInfo notification) {
		(notification.newValue as List<EObject>).flatMapFixedIndexed [ index, value |
			createInsertRootChange(value, notifierResource, initialIndex + index).
				surroundWithCreateAndFeatureChangesIfNecessary().mapFixed[withGeneratedId()]
		]
	}

	private def handleRemoveRootChange(extension NotificationInfo notification) {
		List.of(createRemoveRootChange(oldModelElementValue, notifierResource, position).withGeneratedId())
	}

	private def handleMultiRemoveRootChange(extension NotificationInfo notification) {
		val oldValues = notification.oldValue as List<EObject>
		oldValues.reverseView.mapFixedIndexed [ index, value |
			val valueIndex = initialIndex + oldValues.size - 1 - index
			createRemoveRootChange(value, notifierResource, valueIndex).withGeneratedId()
		]
	}

	private def Iterable<? extends EChange> handleSetUriChange(extension NotificationInfo notification) {
		val oldUri = notification.oldValue as URI
		notifierResource.contents.mapFixedIndexed [ index, value |
			val valueIndex = initialIndex + notifierResource.contents.size - 1 - index
			createRemoveRootChange(value, notifierResource, oldUri, valueIndex).withGeneratedId()
		] + notifierResource.contents.flatMapFixedIndexed [ index, value |
			createInsertRootChange(value, notifierResource, initialIndex + index).
				surroundWithCreateAndFeatureChangesIfNecessary().mapFixed[withGeneratedId()]
		]
	}

	def private Iterable<? extends EChange> allAdditiveChangesForChangeRelevantFeatures(EObject eObject) {
		eObject.walkChangeRelevantFeatures(
			[object, attribute|createAdditiveChangesForValue(object, attribute)],
			[object, reference|if (reference.isContainment) createAdditiveCreateChangesForValue(object, reference)]
		) + eObject.walkChangeRelevantFeatures(null) [ object, reference |
			if (!reference.isContainment) createAdditiveChangesForValue(object, reference)
		]
	}

	def private Iterable<? extends EChange> allSubstractiveChangesForChangeRelevantFeatures(EObject eObject) {
		eObject.walkChangeRelevantFeatures(null) [ object, reference |
			if (!reference.isContainment) createSubtractiveChangesForValue(object, reference)
		] + eObject.walkChangeRelevantFeatures(
			[object, attribute|createSubtractiveChangesForValue(object, attribute)],
			[object, reference|if (reference.isContainment) createSubtractiveChangesForValue(object, reference)]
		)
	}

	def private static Iterable<? extends EChange> walkChangeRelevantFeatures(
		EObject eObject,
		(EObject, EAttribute)=>Iterable<? extends EChange> attributeVisitor,
		(EObject, EReference)=>Iterable<? extends EChange> referenceVisitor
	) {
		val changeRelevantFeatures = eObject.eClass.EAllStructuralFeatures.filter [
			eObject.hasChangeableUnderivedPersistedNotContainingNonDefaultValue(it)
		]
		val thisLayerAttributeResults = changeRelevantFeatures.filter(EAttribute).flatMapFixed [
			attributeVisitor?.apply(eObject, it) ?: emptyList()
		]
		val thisLayerReferenceResults = changeRelevantFeatures.filter(EReference).flatMapFixed [
			referenceVisitor?.apply(eObject, it) ?: emptyList()
		]
		val nextLayer = changeRelevantFeatures.filter(EReference).filter[isContainment].flatMap [
			eObject.getReferencedElements(it)
		].flatMapFixed [
			it.walkChangeRelevantFeatures(attributeVisitor, referenceVisitor)
		]
		thisLayerAttributeResults + thisLayerReferenceResults + nextLayer
	}

	def static private Iterable<EObject> getReferencedElements(EObject eObject, EReference reference) {
		return if (reference.many)
			eObject.eGet(reference) as Iterable<EObject>
		else
			List.of(eObject.eGet(reference) as EObject)
	}

	def private unsetChangeOrEmpty(NotificationInfo notification) {
		if (notification.wasUnset) {
			List.of(createUnsetFeatureChange(notification.notifierModelElement, notification.structuralFeature))
		} else
			emptyList()
	}

	def private <T extends EChange> addUnsetChangeIfNecessary(Iterable<T> changes, NotificationInfo notification) {
		return if (notification.wasUnset)
			changes +
				List.of(createUnsetFeatureChange(notification.notifierModelElement, notification.structuralFeature))
		else
			changes
	}

	def private addUnsetChangeIfNecessary(EChange change, NotificationInfo notification) {
		return if (notification.wasUnset)
			List.of(change, createUnsetFeatureChange(notification.notifierModelElement, notification.structuralFeature))
		else
			List.of(change)
	}

	private def Iterable<? extends EChange> surroundWithCreateAndFeatureChangesIfNecessary(
		EObjectAddedEChange<?> change) {
		return if (eChangeIdManager.isCreateChange(change)) {
			val createChange = createCreateEObjectChange(change.newValue)
			List.of(createChange, change) + allAdditiveChangesForChangeRelevantFeatures(change.newValue)
		} else
			List.of(change)
	}

	def private <T extends EChange> withGeneratedId(T change) {
		eChangeIdManager.setOrGenerateIds(change)
		return change
	}
}
