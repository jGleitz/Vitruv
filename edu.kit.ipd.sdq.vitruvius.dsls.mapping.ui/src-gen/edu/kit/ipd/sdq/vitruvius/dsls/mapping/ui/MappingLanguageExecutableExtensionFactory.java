/*
 * generated by Xtext
 */
package edu.kit.ipd.sdq.vitruvius.dsls.mapping.ui;

import org.eclipse.xtext.ui.guice.AbstractGuiceAwareExecutableExtensionFactory;
import org.osgi.framework.Bundle;

import com.google.inject.Injector;

import edu.kit.ipd.sdq.vitruvius.dsls.mapping.ui.internal.MappingLanguageActivator;

/**
 * This class was generated. Customizations should only happen in a newly
 * introduced subclass. 
 */
public class MappingLanguageExecutableExtensionFactory extends AbstractGuiceAwareExecutableExtensionFactory {

	@Override
	protected Bundle getBundle() {
		return MappingLanguageActivator.getInstance().getBundle();
	}
	
	@Override
	protected Injector getInjector() {
		return MappingLanguageActivator.getInstance().getInjector(MappingLanguageActivator.EDU_KIT_IPD_SDQ_VITRUVIUS_DSLS_MAPPING_MAPPINGLANGUAGE);
	}
	
}
