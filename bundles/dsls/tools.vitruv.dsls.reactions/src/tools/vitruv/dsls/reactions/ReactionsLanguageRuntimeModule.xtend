/*
 * generated by Xtext 2.9.0
 */
package tools.vitruv.dsls.reactions

import org.eclipse.xtext.scoping.IGlobalScopeProvider
import com.google.inject.name.Names
import com.google.inject.Binder
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.linking.ILinkingService
import tools.vitruv.dsls.reactions.linking.ReactionsLinkingService
import tools.vitruv.dsls.reactions.scoping.ReactionsLanguageScopeProviderDelegate
import tools.vitruv.dsls.reactions.scoping.ReactionsLanguageGlobalScopeProvider
import tools.vitruv.dsls.mirbase.scoping.MirBaseQualifiedNameConverter
import org.eclipse.xtext.generator.IGenerator2
import tools.vitruv.dsls.reactions.generator.ReactionsLanguageGenerator
import tools.vitruv.dsls.reactions.generator.InternalReactionsGenerator
import tools.vitruv.dsls.reactions.api.generator.IReactionsGenerator
import tools.vitruv.dsls.reactions.generator.ExternalReactionsGenerator
import org.eclipse.xtext.formatting2.IFormatter2
import tools.vitruv.dsls.reactions.formatting2.ReactionsLanguageFormatter
import tools.vitruv.dsls.reactions.builder.FluentReactionsLanguageBuilder

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class ReactionsLanguageRuntimeModule extends AbstractReactionsLanguageRuntimeModule {
	public override Class<? extends IGlobalScopeProvider> bindIGlobalScopeProvider() {
		return ReactionsLanguageGlobalScopeProvider;
	}

	public override void configureIScopeProviderDelegate(Binder binder) {
		binder.bind(org.eclipse.xtext.scoping.IScopeProvider)
		      .annotatedWith(Names.named(org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider.NAMED_DELEGATE))
		      .to(ReactionsLanguageScopeProviderDelegate);
	}
	
	public override Class<? extends IQualifiedNameConverter> bindIQualifiedNameConverter() {
		return MirBaseQualifiedNameConverter;
	}
	
	public override Class<? extends ILinkingService> bindILinkingService() {
		return ReactionsLinkingService;
	}
	
	def Class<? extends IGenerator2> bindIGenerator2() {
		ReactionsLanguageGenerator
	}
	
	def Class<? extends IReactionsGenerator> bindIReactionsGenerator() {
		InternalReactionsGenerator
	}
	
	override configure(Binder binder) {
		super.configure(binder);
		binder.bind(IGenerator2).to(bindIGenerator2())
		binder.bind(IReactionsGenerator).to(bindIReactionsGenerator())

		binder.requestStaticInjection(ExternalReactionsGenerator)
		binder.requestStaticInjection(FluentReactionsLanguageBuilder)
	}
	
}
