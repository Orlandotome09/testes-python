@functional
Feature: Journey Maquinininha Portal Customer Company


	Scenario: Should approve profile when it meets all the requirements
		Given mock bureau "cnpj-no-participation"
		Given create customer PJ with partner "BexsBanco", offer "MaquininhaPortal"
		When that we update the annual income and assets values
		When add the address
		When we include a contact
		When we include the second contact
		When we include the legal representative
		When we include the address for legal representative
		When add the document "CORPORATE_DOCUMENT", number "123" and name "testeqa"
		When add the file
		When I include a shareholder with percent 95
		When we include the address for shareholder
		Then I check the "ANALYSING" compliance status
		Then I verify that there is no limit for this profile
		When I update the legal representative
		When I enclose the "IDENTIFICATION", sub type "RG", number "1234" and name "TestqaP" for the legal representative
		When add the file in document for legal representative
		When Approve rule manual validation
		When Override of ownership structure
		When check approved
		Then I check that the profile is not eligible for the custom limit
		Then check assigned limit 100000
		Then I check the assigned limit 100000 in Fx integrator
		When add the document "FINANCIAL_STATEMENT", number "123" and name "testeqa"
		When add the file
		Then I check eligibility for custom limit
		When I assign the custom limit
		Then I check if the eligibility flag is False
		Then I check the assigned custom limit
		Then I check the assigned limit 200000 in Fx integrator
		When add the document "PROOF_OF_FINANCIAL_STANDING", number "123" and name "testeqa"
		When add the document "APPOINTMENT_DOCUMENT", number "123" and name "testeqa"
		When add the document with subtype "CONSTITUTION_DOCUMENT", sub type "SOCIAL_CONTRACT", number "123" and name "Testqa"
		When add the document with subtype "PROOF_OF_SHAREHOLDER_CHAIN", sub type "ORGANOGRAM", number "123" and name "Testqa"
		When add the document "RADAR", number "123" and name "testeqa"
		When add the document "OTHERS", number "123" and name "Other document"
		When I include the contact
		When I include the question forms
		Then I check the "APPROVED" status of the onboarding status


	Scenario: Created profile is not approved since it is INCOMPLETE
		Given mock bureau "cnpj-regular"
		Given create customer PJ with partner "BexsBanco", offer "MaquininhaPortal"
		When check for missing ADDRESS_NOT_FOUND and DOCUMENT_NOT_FOUND_CORPORATE_DOCUMENT
		Then I check the "INCOMPLETE" status of the onboarding status

	Scenario:  Created profile is not approved since shareholding is bellow 95%
		Given mock bureau "cnpj-no-participation"
		Given create customer PJ with partner "BexsBanco", offer "MaquininhaPortal"
		When that we update the annual income and assets values
		When add the address
		When add the document "CORPORATE_DOCUMENT", number "123" and name "testeqa"
		When add the file
		When Approve rule manual validation
		When I include a shareholder with percent 80
		When check compliance not aproved Shareholder minimum required
		Then I check the "ANALYSING" status of the onboarding status

	Scenario: Created profile is not approved since Legal Representative is not approved
		Given mock bureau "cnpj-no-participation"
		Given create customer PJ with partner "BexsBanco", offer "MaquininhaPortal"
		When that we update the annual income and assets values
		When add the address
		When add the document "CORPORATE_DOCUMENT", number "123" and name "testeqa"
		When add the file
		When Approve rule manual validation
		When I include a shareholder with percent 95
		When we include the legal representative is pep
		When check compliance not aproved legal representative
		Then I check the "ANALYSING" status of the onboarding status
