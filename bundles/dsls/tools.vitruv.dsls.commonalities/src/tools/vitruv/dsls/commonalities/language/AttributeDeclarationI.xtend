package tools.vitruv.dsls.commonalities.language

import tools.vitruv.dsls.commonalities.language.elements.WellKnownClassifiers
import tools.vitruv.dsls.commonalities.language.impl.AttributeDeclarationImpl

import static extension edu.kit.ipd.sdq.commons.util.java.lang.IterableUtil.*
import static extension tools.vitruv.dsls.commonalities.language.extensions.CommonalitiesLanguageModelExtensions.*

class AttributeDeclarationI extends AttributeDeclarationImpl {

	override basicGetClassLikeContainer() {
		containingCommonalityFile.commonality
	}

	override isMultiValued() {
		mappings.containsAny[attribute.isMultiValued]
	}

	override getType() {
		if (mappings.length === 0) return WellKnownClassifiers.JAVA_OBJECT;

		val mappingIterator = mappings.iterator
		val firstMapping = mappingIterator.next
		var requiredType = firstMapping.requiredType
		var providedType = firstMapping.providedType
		for (var AttributeMappingSpecifiation mapping; mappingIterator.hasNext; mapping = mappingIterator.next) {
			// if this is not the case, the specification itself is invalid, so we skip it.
			if (mapping !== null && mapping.requiredType.isSuperTypeOf(mapping.providedType)) {
				if (!mapping.requiredType.isSuperTypeOf(requiredType)) {
					if (mapping.requiredType.isSuperTypeOf(providedType)) {
						requiredType = mapping.requiredType
					} else {
						// specification not compatible to others
					}
				}
				if (!providedType.isSuperTypeOf(mapping.providedType)) {
					if (requiredType.isSuperTypeOf(mapping.providedType)) {
						providedType = mapping.providedType
					}
				}
			}
		}

		// we know that requiredType.isSuperTypeOf(providedType)
		return if (providedType != WellKnownClassifiers.MOST_SPECIFIC_TYPE) providedType else requiredType
	}
	
	override toString() {
		'''«classLikeContainer».«name»'''
	}
	
}
