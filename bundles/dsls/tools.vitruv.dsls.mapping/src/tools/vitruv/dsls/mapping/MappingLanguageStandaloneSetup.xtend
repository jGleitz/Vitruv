/*
 * generated by Xtext 2.10.0-SNAPSHOT
 */
package tools.vitruv.dsls.mapping


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MappingLanguageStandaloneSetup extends MappingLanguageStandaloneSetupGenerated {

	def static void doSetup() {
		new MappingLanguageStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}