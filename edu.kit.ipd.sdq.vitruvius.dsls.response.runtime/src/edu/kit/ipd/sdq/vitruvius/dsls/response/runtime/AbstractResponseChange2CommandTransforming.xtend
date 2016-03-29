package edu.kit.ipd.sdq.vitruvius.dsls.response.runtime

import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.Change2CommandTransforming
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Blackboard
import org.apache.log4j.Logger
import java.util.List
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.Change
import org.eclipse.emf.common.command.Command
import java.util.ArrayList
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.CompositeChange
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.EMFModelChange
import edu.kit.ipd.sdq.vitruvius.framework.meta.change.EChange;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.UserInteracting
import edu.kit.ipd.sdq.vitruvius.framework.model.monitor.userinteractor.UserInteractor

abstract class AbstractResponseChange2CommandTransforming implements Change2CommandTransforming {
	private final static val LOGGER = Logger.getLogger(AbstractResponseChange2CommandTransforming);
	
	private List<AbstractResponseExecutor> responseExecutors;

	protected UserInteracting userInteracting;
	
	new() {
		this.responseExecutors = new ArrayList<AbstractResponseExecutor>();
		setUserInteracting(new UserInteractor());
	}

	protected def void addResponseExecutor(AbstractResponseExecutor executor) {
		this.responseExecutors.add(executor);
	}
	
	override transformChanges2Commands(Blackboard blackboard) {
		val changes = blackboard.getAndArchiveChangesForTransformation();
		val commands = new ArrayList<Command>();

		for (Change change : changes) {
			commands.addAll(this.handleChange(change, blackboard));
		}

		blackboard.pushCommands(commands);
	}

	private def List<Command> handleChange(Change change, Blackboard blackboard) {
		val result = new ArrayList<Command>();
		if (change instanceof CompositeChange) {
			for (Change c : (change as CompositeChange).getChanges()) {
				result.addAll(this.handleChange(c, blackboard));
			}
		} else if (change instanceof EMFModelChange) {
			result.addAll(this.handleEChange((change as EMFModelChange).getEChange(), blackboard));
		} else {
			throw new IllegalArgumentException("Change subtype " + change.getClass().getName() + " not handled");
		}

		return result;
	}
	
	private def List<Command> handleEChange(EChange change, Blackboard blackboard) {
		val result = new ArrayList<Command>();
		for (executor : responseExecutors) {
			LOGGER.debug('''Calling executor «executor» for change event «change»''');
			result += executor.generateCommandsForEvent(change, blackboard);
		}
		return result;
	}

	override setUserInteracting(UserInteracting userInteracting) {
		this.userInteracting = userInteracting;
		this.cleanAndSetup();
	}

	private def void cleanAndSetup() {
		this.responseExecutors.clear();
		setup();
	}
	
	protected abstract def void setup();
	
}