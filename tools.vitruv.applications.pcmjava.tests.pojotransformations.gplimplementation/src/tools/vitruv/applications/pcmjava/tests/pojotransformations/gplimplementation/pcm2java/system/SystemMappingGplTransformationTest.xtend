package tools.vitruv.applications.pcmjava.tests.pojotransformations.gplimplementation.pcm2java.system

import tools.vitruv.applications.pcmjava.tests.pojotransformations.pcm2java.system.SystemMappingTransformationTest

class SystemMappingGplTransformationTest extends SystemMappingTransformationTest {
	override protected createChange2CommandTransformingProviding() {
		Change2CommandTransformingProvidingFactory.createPcm2JavaGplImplementationTransformingProviding();
	}
}