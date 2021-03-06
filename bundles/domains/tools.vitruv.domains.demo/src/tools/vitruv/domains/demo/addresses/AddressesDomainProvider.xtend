package tools.vitruv.domains.demo.addresses

import tools.vitruv.framework.domains.VitruvDomainProvider

class AddressesDomainProvider implements VitruvDomainProvider<AddressesDomain> {
	static var AddressesDomain instance

	override AddressesDomain getDomain() {
		if (instance === null) {
			instance = new AddressesDomain()
		}
		return instance
	}
}
