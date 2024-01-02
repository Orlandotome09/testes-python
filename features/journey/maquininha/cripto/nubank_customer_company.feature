@functional
Feature: Journey Maquinininha Cripto Customer Company


	Scenario: Should approve profile when it meets all the requirements
		Given mock bureau "cnpj-regular"
		Given create customer PJ with partner "NUBANK", offer "MaquininhaCripto"
		When that we update the annual income and assets values
		When we include the legal representative
		When we include the address for legal representative
		When add the document "CORPORATE_DOCUMENT", number "123" and name "testeqa"
		When add the file
		When add the address
		Then I check the "ANALYSING" compliance status
		Then I verify that there is no limit for this profile
		When I update the legal representative
		When I enclose the "IDENTIFICATION", sub type "RG", number "1234" and name "TestqaP" for the legal representative
		When add the file in document for legal representative
		When Approve rule manual validation
		When Override of ownership structure
		When check approved
		Then I check eligibility for custom limit
		Then I check the "ANALYSING" status of the onboarding status
		When I assign the custom limit
		Then I check if the eligibility flag is False
		Then I check the assigned custom limit
		Then I check the assigned limit 200000 in Fx integrator
		Then I check the "APPROVED" status of the onboarding status
