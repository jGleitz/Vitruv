package tools.vitruv.dsls.commonalities.language

import tools.vitruv.dsls.commonalities.language.impl.ParticipationClassImpl

import static extension tools.vitruv.dsls.commonalities.language.extensions.CommonalitiesLanguageModelExtensions.*

package class ParticipationClassI extends ParticipationClassImpl {

	override getName() {
		classAlias ?: getSuperMetaclass()?.name
	}

	override basicGetPackageLikeContainer() {
		getOptionalEContainer(Participation)
	}

	override toString() {
		'''«packageLikeContainer»:«name»'''
	}
}
