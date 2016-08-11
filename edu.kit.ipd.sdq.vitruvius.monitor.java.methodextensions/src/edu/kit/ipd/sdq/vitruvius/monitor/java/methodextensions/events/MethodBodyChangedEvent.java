package edu.kit.ipd.sdq.vitruvius.monitor.java.methodextensions.events;

import org.eclipse.jdt.core.dom.MethodDeclaration;

/**
 * Extension event for a method body change event.
 * 
 * @author Stephan Seifermann
 *
 */
public class MethodBodyChangedEvent extends ChangeClassifiyingEventExtensionBase<MethodDeclaration> {

    /**
     * Constructor.
     * 
     * @param originalMethodDeclaration
     *            The method declaration, which contains the unchanged body.
     * @param changedMethodDeclaration
     *            The method declaration, which contains the changed body.
     */
    public MethodBodyChangedEvent(MethodDeclaration originalMethodDeclaration,
            MethodDeclaration changedMethodDeclaration) {
        super(originalMethodDeclaration, changedMethodDeclaration);
    }

}
