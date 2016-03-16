/**
 */
package edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.change.feature.list.impl;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.change.feature.impl.UpdateMultiValuedEFeatureImpl;

import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.change.feature.list.ListPackage;
import edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.change.feature.list.PermuteEList;

import java.util.Collection;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.util.EDataTypeUniqueEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Permute EList</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link edu.kit.ipd.sdq.vitruvius.framework.contracts.meta.change.feature.list.impl.PermuteEListImpl#getNewIndicesForElementsAtOldIndices <em>New Indices For Elements At Old Indices</em>}</li>
 * </ul>
 *
 * @generated
 */
public abstract class PermuteEListImpl extends UpdateMultiValuedEFeatureImpl implements PermuteEList {
    /**
     * The cached value of the '{@link #getNewIndicesForElementsAtOldIndices() <em>New Indices For Elements At Old Indices</em>}' attribute list.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see #getNewIndicesForElementsAtOldIndices()
     * @generated
     * @ordered
     */
    protected EList<Integer> newIndicesForElementsAtOldIndices;

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    protected PermuteEListImpl() {
        super();
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    protected EClass eStaticClass() {
        return ListPackage.Literals.PERMUTE_ELIST;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    public EList<Integer> getNewIndicesForElementsAtOldIndices() {
        if (newIndicesForElementsAtOldIndices == null) {
            newIndicesForElementsAtOldIndices = new EDataTypeUniqueEList<Integer>(Integer.class, this, ListPackage.PERMUTE_ELIST__NEW_INDICES_FOR_ELEMENTS_AT_OLD_INDICES);
        }
        return newIndicesForElementsAtOldIndices;
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public Object eGet(int featureID, boolean resolve, boolean coreType) {
        switch (featureID) {
            case ListPackage.PERMUTE_ELIST__NEW_INDICES_FOR_ELEMENTS_AT_OLD_INDICES:
                return getNewIndicesForElementsAtOldIndices();
        }
        return super.eGet(featureID, resolve, coreType);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @SuppressWarnings("unchecked")
    @Override
    public void eSet(int featureID, Object newValue) {
        switch (featureID) {
            case ListPackage.PERMUTE_ELIST__NEW_INDICES_FOR_ELEMENTS_AT_OLD_INDICES:
                getNewIndicesForElementsAtOldIndices().clear();
                getNewIndicesForElementsAtOldIndices().addAll((Collection<? extends Integer>)newValue);
                return;
        }
        super.eSet(featureID, newValue);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public void eUnset(int featureID) {
        switch (featureID) {
            case ListPackage.PERMUTE_ELIST__NEW_INDICES_FOR_ELEMENTS_AT_OLD_INDICES:
                getNewIndicesForElementsAtOldIndices().clear();
                return;
        }
        super.eUnset(featureID);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public boolean eIsSet(int featureID) {
        switch (featureID) {
            case ListPackage.PERMUTE_ELIST__NEW_INDICES_FOR_ELEMENTS_AT_OLD_INDICES:
                return newIndicesForElementsAtOldIndices != null && !newIndicesForElementsAtOldIndices.isEmpty();
        }
        return super.eIsSet(featureID);
    }

    /**
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    @Override
    public String toString() {
        if (eIsProxy()) return super.toString();

        StringBuffer result = new StringBuffer(super.toString());
        result.append(" (newIndicesForElementsAtOldIndices: ");
        result.append(newIndicesForElementsAtOldIndices);
        result.append(')');
        return result.toString();
    }

} //PermuteEListImpl
