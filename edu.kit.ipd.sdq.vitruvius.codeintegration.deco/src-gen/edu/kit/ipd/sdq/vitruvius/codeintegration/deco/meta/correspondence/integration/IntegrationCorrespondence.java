/**
 */
package edu.kit.ipd.sdq.vitruvius.codeintegration.deco.meta.correspondence.integration;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.correspondence.Correspondence;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Correspondence</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.codeintegration.deco.meta.correspondence.integration.IntegrationCorrespondence#isCreatedByIntegration <em>Created By Integration</em>}</li>
 * </ul>
 *
 * @see edu.kit.ipd.sdq.vitruvius.codeintegration.deco.meta.correspondence.integration.IntegrationPackage#getIntegrationCorrespondence()
 * @model
 * @generated
 */
public interface IntegrationCorrespondence extends Correspondence {

    /**
     * Returns the value of the '<em><b>Created By Integration</b></em>' attribute.
     * The default value is <code>"false"</code>.
     * <!-- begin-user-doc -->
     * <p>
     * If the meaning of the '<em>Created By Integration</em>' attribute isn't clear,
     * there really should be more of a description here...
     * </p>
     * <!-- end-user-doc -->
     * @return the value of the '<em>Created By Integration</em>' attribute.
     * @see #setCreatedByIntegration(boolean)
     * @see edu.kit.ipd.sdq.vitruvius.codeintegration.deco.meta.correspondence.integration.IntegrationPackage#getIntegrationCorrespondence_CreatedByIntegration()
     * @model default="false"
     * @generated
     */
    boolean isCreatedByIntegration();

    /**
     * Sets the value of the '{@link edu.kit.ipd.sdq.vitruvius.codeintegration.deco.meta.correspondence.integration.IntegrationCorrespondence#isCreatedByIntegration <em>Created By Integration</em>}' attribute.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @param value the new value of the '<em>Created By Integration</em>' attribute.
     * @see #isCreatedByIntegration()
     * @generated
     */
    void setCreatedByIntegration(boolean value);
} // IntegrationCorrespondence