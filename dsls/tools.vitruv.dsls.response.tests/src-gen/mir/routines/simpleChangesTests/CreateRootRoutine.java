package mir.routines.simpleChangesTests;

import allElementTypes.Root;
import allElementTypes.impl.AllElementTypesFactoryImpl;
import java.io.IOException;
import mir.routines.simpleChangesTests.RoutinesFacade;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.xbase.lib.Extension;
import tools.vitruv.extensions.dslsruntime.response.AbstractRepairRoutineRealization;
import tools.vitruv.extensions.dslsruntime.response.ResponseExecutionState;
import tools.vitruv.extensions.dslsruntime.response.structure.CallHierarchyHaving;

@SuppressWarnings("all")
public class CreateRootRoutine extends AbstractRepairRoutineRealization {
  private RoutinesFacade effectFacade;
  
  private CreateRootRoutine.EffectUserExecution userExecution;
  
  private static class EffectUserExecution extends AbstractRepairRoutineRealization.UserExecution {
    public EffectUserExecution(final ResponseExecutionState responseExecutionState, final CallHierarchyHaving calledBy) {
      super(responseExecutionState);
    }
    
    public EObject getElement1(final Root root, final Root newRoot) {
      return newRoot;
    }
    
    public void updateNewRootElement(final Root root, final Root newRoot) {
      String _id = root.getId();
      newRoot.setId(_id);
    }
    
    public EObject getElement2(final Root root, final Root newRoot) {
      return root;
    }
    
    public void callRoutine1(final Root root, final Root newRoot, @Extension final RoutinesFacade _routinesFacade) {
      String _id = root.getId();
      String _replace = _id.replace("Source", "Target");
      String _plus = ("model/" + _replace);
      this.persistProjectRelative(root, newRoot, _plus);
    }
  }
  
  public CreateRootRoutine(final ResponseExecutionState responseExecutionState, final CallHierarchyHaving calledBy, final Root root) {
    super(responseExecutionState, calledBy);
    this.userExecution = new mir.routines.simpleChangesTests.CreateRootRoutine.EffectUserExecution(getExecutionState(), this);
    this.effectFacade = new mir.routines.simpleChangesTests.RoutinesFacade(getExecutionState(), this);
    this.root = root;
  }
  
  private Root root;
  
  protected void executeRoutine() throws IOException {
    getLogger().debug("Called routine CreateRootRoutine with input:");
    getLogger().debug("   Root: " + this.root);
    
    Root newRoot = AllElementTypesFactoryImpl.eINSTANCE.createRoot();
    initializeCreateElementState(newRoot);
    userExecution.updateNewRootElement(root, newRoot);
    
    addCorrespondenceBetween(userExecution.getElement1(root, newRoot), userExecution.getElement2(root, newRoot), "");
    
    userExecution.callRoutine1(root, newRoot, effectFacade);
    
    postprocessElementStates();
  }
}
