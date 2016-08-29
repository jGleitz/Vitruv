package edu.kit.ipd.sdq.vitruvius.codeintegration.change2command

import edu.kit.ipd.sdq.vitruvius.framework.changes.changeprocessor.AbstractChangeProcessor
import edu.kit.ipd.sdq.vitruvius.framework.contracts.interfaces.UserInteracting
import edu.kit.ipd.sdq.vitruvius.framework.contracts.change.ConcreteChange
import edu.kit.ipd.sdq.vitruvius.framework.contracts.datatypes.CorrespondenceModel
import java.util.ArrayList
import edu.kit.ipd.sdq.vitruvius.framework.changes.echange.EChange
import org.eclipse.emf.common.command.Command
import edu.kit.ipd.sdq.vitruvius.framework.contracts.change.VitruviusChangeFactory
import edu.kit.ipd.sdq.vitruvius.framework.changes.changeprocessor.ChangeProcessorResult
import edu.kit.ipd.sdq.vitruvius.codeintegration.change2command.internal.IntegrationChange2CommandTransformer

class CodeIntegrationChangeProcessor extends AbstractChangeProcessor {
	private val IntegrationChange2CommandTransformer integrationTransformer;
	
	new(UserInteracting userInteracting) {
		super(userInteracting);
		this.integrationTransformer = new IntegrationChange2CommandTransformer(getUserInteracting());
	}
	
	override transformChange(ConcreteChange change, CorrespondenceModel correspondenceModel) {
		val nonIntegratedEChanges = new ArrayList<EChange>();
		val commands = new ArrayList<Command>();
		for (eChange : change.getEChanges) {
			// Special behavior for changes to integrated elements
			val integrationTransformResult = integrationTransformer.compute(eChange, correspondenceModel);
        	if (integrationTransformResult.isIntegrationChange()) {
        		commands += integrationTransformResult.getCommands();
			} else {
				nonIntegratedEChanges += eChange;
			}
		}
		val resultingChange = if (nonIntegratedEChanges.isEmpty) {
			VitruviusChangeFactory.instance.createEmptyChange(change.getURI);
		} else {
			VitruviusChangeFactory.instance.createGeneralChange(nonIntegratedEChanges, change.getURI);
		}
		
		return new ChangeProcessorResult(resultingChange, commands);
	}
	
}