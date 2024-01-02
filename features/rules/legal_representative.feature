# @parallel=false
# Feature: Legal Representative Rule

# 	Background:
# 		* url registrationUrlInt
# 		* def createProfileCustomerCompany = read('../_data/profileCompany.js')
# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def createDocument = read('../_data/documentByType.js')
# 		* def createLegalRepresentative = read('../_data/legalRepresentative.js')
# 		* def createShareholder = read('../_data/shareholder.js')
# 		* def createFullDocument = read('../_data/documentByTypeAndSubtype.js')

# 	Scenario: Should Created profile has not been approved because the Legal Representative is included in the PEP rule

# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfileCustomerCompany  { partner_id: '#(PartnerID.BexsBanco)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaPortal)', role_type: 'CUSTOMER'}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-no-participation"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given path '/profile/' + profileID
# 		And header Content-Type = 'application/json'
# 		And profile.company.assets = 123.45
# 		And profile.company.annual_income = 1000.01
# 		And request profile
# 		When method PATCH
# 		Then assert responseStatus == 200
# 		And assert response.company.assets == 123.45
# 		And assert response.company.annual_income == 1000.01

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "18751-152",
# 			street: "Rua Maria Eugênia",
# 			number: "4567",
# 			complement: "Perto da sorveteria",
# 			neighborhood: "Paraíso",
# 			city: "São Paulo",
# 			state_code: "SP",
# 			country_code: "BRA"
# 			}
# 			"""

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def document = call createDocument { type: 'CORPORATE_DOCUMENT'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def shareholder =  call createShareholder { document_number: '#(CPFGenerator())', percent: 95.0, offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}
# 		* shareholder.date_of_birth = "01/01/2000"
# 		* shareholder.person_type = "INDIVIDUAL"
# 		* shareholder.level = 1

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/shareholders'
# 		And request shareholder
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/override'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/override.js')
# 		And def override = call func { entityID : '#(profileID)' , ruleSet: "SERASA_BUREAU" , ruleName: "CUSTOMER_HAS_PROBLEMS_IN_SERASA" , result : "#(RuleResult.Approved)" }
# 		And request override
# 		When method POST
# 		Then assert responseStatus == 200

# 		* def legaRepresentative = call createLegalRepresentative { document_number: '#(CPFGenerator())', offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}
# 		* legaRepresentative.pep = true
# 		* legaRepresentative.us_person = true

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/legal-representative'
# 		And header Content-Type = 'application/json'
# 		And request legaRepresentative
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legalRepresentativeID = response.legal_representative_id
# 		* def legalRepresentativeDocument = call createFullDocument { type : "IDENTIFICATION", sub_type : "RG"}

# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID + '/document'
# 		And header Content-Type = 'application/json'
# 		And request legalRepresentativeDocument
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200
# 		And assert response.detailed_result[0].details[0].code == "LEGAL_REPRESENTATIVE_NOT_APPROVED"

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		And path '/state/' + legalRepresentativeID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(legalRepresentativeID)', result: '#(RuleResult.Analysing)' }
# 		And match response.rule_set_result contains deep { step_number: 0, set: 'PEP', name: 'PEP', result: '#(RuleResult.Analysing)', pending: true, metadata:{pep_sources:["SELF_DECLARED"]}}


# 	Scenario: Should Created profile approved because the Legal Representative is pending in serasa

		
# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfileCustomerCompany  { partner_id: '#(PartnerID.BexsBanco)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaPortal)', role_type: 'CUSTOMER'}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-no-participation"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given path '/profile/' + profileID
# 		And header Content-Type = 'application/json'
# 		And profile.company.assets = 123.45
# 		And profile.company.annual_income = 1000.01
# 		And request profile
# 		When method PATCH
# 		Then assert responseStatus == 200
# 		And assert response.company.assets == 123.45
# 		And assert response.company.annual_income == 1000.01

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "18751-152",
# 			street: "Rua Maria Eugênia",
# 			number: "4567",
# 			complement: "Perto da sorveteria",
# 			neighborhood: "Paraíso",
# 			city: "São Paulo",
# 			state_code: "SP",
# 			country_code: "BRA"
# 			}
# 			"""

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def document = call createDocument { type: 'CORPORATE_DOCUMENT'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def shareholder =  call createShareholder { document_number: '#(CPFGenerator())', percent: 95.0, offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}
# 		* shareholder.date_of_birth = "01/01/2000"
# 		* shareholder.person_type = "INDIVIDUAL"
# 		* shareholder.level = 1

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/shareholders'
# 		And request shareholder
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/override'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/override.js')
# 		And def override = call func { entityID : '#(profileID)' , ruleSet: "SERASA_BUREAU" , ruleName: "CUSTOMER_HAS_PROBLEMS_IN_SERASA" , result : "#(RuleResult.Approved)" }
# 		And request override
# 		When method POST
# 		Then assert responseStatus == 200

# 		* def documentNumber =  CPFGenerator()

# 		Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-pending"}
#         When method POST
#         Then assert responseStatus == 200

# 		* def legaRepresentative = call createLegalRepresentative { document_number: '#(documentNumber)', offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/legal-representative'
# 		And header Content-Type = 'application/json'
# 		And request legaRepresentative
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legalRepresentativeID = response.legal_representative_id
# 		* def legalRepresentativeDocument = call createFullDocument { type : "IDENTIFICATION", sub_type : "RG"}

# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID + '/document'
# 		And header Content-Type = 'application/json'
# 		And request legalRepresentativeDocument
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		And path '/state/' + legalRepresentativeID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(legalRepresentativeID)', result: '#(RuleResult.Approved)' }

# 	Scenario: Should Created profile has not been approved because the Legal Representative is present in blacklist

		
# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfileCustomerCompany  { partner_id: '#(PartnerID.BexsBanco)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaPortal)', role_type: 'CUSTOMER'}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-no-participation"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given path '/profile/' + profileID
# 		And header Content-Type = 'application/json'
# 		And profile.company.assets = 123.45
# 		And profile.company.annual_income = 1000.01
# 		And request profile
# 		When method PATCH
# 		Then assert responseStatus == 200
# 		And assert response.company.assets == 123.45
# 		And assert response.company.annual_income == 1000.01

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "18751-152",
# 			street: "Rua Maria Eugênia",
# 			number: "4567",
# 			complement: "Perto da sorveteria",
# 			neighborhood: "Paraíso",
# 			city: "São Paulo",
# 			state_code: "SP",
# 			country_code: "BRA"
# 			}
# 			"""

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def document = call createDocument { type: 'CORPORATE_DOCUMENT'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def shareholder =  call createShareholder { document_number: '#(CPFGenerator())', percent: 95.0, offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}
# 		* shareholder.date_of_birth = "01/01/2000"
# 		* shareholder.person_type = "INDIVIDUAL"
# 		* shareholder.level = 1

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/shareholders'
# 		And request shareholder
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/override'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/override.js')
# 		And def override = call func { entityID : '#(profileID)' , ruleSet: "SERASA_BUREAU" , ruleName: "CUSTOMER_HAS_PROBLEMS_IN_SERASA" , result : "#(RuleResult.Approved)" }
# 		And request override
# 		When method POST
# 		Then assert responseStatus == 200

# 		* def documentNumber =  CPFGenerator()
# 		* def blacklistBody = { justification: 'Present Black List', full_name: 'Test Blacklist PF', document_number: '#(documentNumber)', person_type: "INDIVIDUAL"}

# 		Given url temis_restrictive_list
# 		And path '/internal-list'
# 		And request blacklistBody
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legaRepresentative = call createLegalRepresentative { document_number: '#(documentNumber)', offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/legal-representative'
# 		And header Content-Type = 'application/json'
# 		And request legaRepresentative
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legalRepresentativeID = response.legal_representative_id
# 		* def legalRepresentativeDocument = call createFullDocument { type : "IDENTIFICATION", sub_type : "RG"}

# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID + '/document'
# 		And header Content-Type = 'application/json'
# 		And request legalRepresentativeDocument
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200
# 		And assert response.detailed_result[0].details[0].code == "LEGAL_REPRESENTATIVE_NOT_APPROVED"

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		And path '/state/' + legalRepresentativeID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(legalRepresentativeID)', result: '#(RuleResult.Analysing)' }
# 		And match response.rule_set_result contains { step_number: 0, set: 'BLACKLIST', name: 'BLACKLIST', result: '#(RuleResult.Analysing)', pending: true, metadata: '##notnull'}


# 	Scenario: Should Created profile has not been approved because the Legal Representative is present in Watchlist

		
# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfileCustomerCompany  { partner_id: '#(PartnerID.BexsBanco)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaPortal)', role_type: 'CUSTOMER'}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-no-participation"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given path '/profile/' + profileID
# 		And header Content-Type = 'application/json'
# 		And profile.company.assets = 123.45
# 		And profile.company.annual_income = 1000.01
# 		And request profile
# 		When method PATCH
# 		Then assert responseStatus == 200
# 		And assert response.company.assets == 123.45
# 		And assert response.company.annual_income == 1000.01

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "18751-152",
# 			street: "Rua Maria Eugênia",
# 			number: "4567",
# 			complement: "Perto da sorveteria",
# 			neighborhood: "Paraíso",
# 			city: "São Paulo",
# 			state_code: "SP",
# 			country_code: "BRA"
# 			}
# 			"""

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def document = call createDocument { type: 'CORPORATE_DOCUMENT'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def shareholder =  call createShareholder { document_number: '#(CPFGenerator())', percent: 95.0, offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}
# 		* shareholder.date_of_birth = "01/01/2000"
# 		* shareholder.person_type = "INDIVIDUAL"
# 		* shareholder.level = 1

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/shareholders'
# 		And request shareholder
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/override'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/override.js')
# 		And def override = call func { entityID : '#(profileID)' , ruleSet: "SERASA_BUREAU" , ruleName: "CUSTOMER_HAS_PROBLEMS_IN_SERASA" , result : "#(RuleResult.Approved)" }
# 		And request override
# 		When method POST
# 		Then assert responseStatus == 200

# 		* def documentNumber =  CPFGenerator()
# 		* def WatchlistBody = { document_number: "#(documentNumber)", title:"SomeToken", name: "Someone", link: "/link", watch: "", other: "", entries: ["someEntry"], sources: ["OFAC_CAPTA"]}

# 		Given url temis_mock
# 		And path '/compliance/watchlist'
# 		And request WatchlistBody
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legaRepresentative = call createLegalRepresentative { document_number: '#(documentNumber)', offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/legal-representative'
# 		And header Content-Type = 'application/json'
# 		And request legaRepresentative
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legalRepresentativeID = response.legal_representative_id
# 		* def legalRepresentativeDocument = call createFullDocument { type : "IDENTIFICATION", sub_type : "RG"}

# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID + '/document'
# 		And header Content-Type = 'application/json'
# 		And request legalRepresentativeDocument
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200
# 		And assert response.detailed_result[0].details[0].code == "LEGAL_REPRESENTATIVE_NOT_APPROVED"

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		And path '/state/' + legalRepresentativeID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(legalRepresentativeID)', result: '#(RuleResult.Analysing)' }
# 		And match response.rule_set_result contains { step_number: 0, set: 'WATCHLIST', name: 'WATCHLIST', result: '#(RuleResult.Analysing)', pending: true, metadata: '##notnull', problems: '##notnull'}


# 	Scenario: Should Created profile has not been approved because the Legal Representative is incomplete

		
# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfileCustomerCompany  { partner_id: '#(PartnerID.BexsBanco)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaPortal)', role_type: 'CUSTOMER'}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-no-participation"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given path '/profile/' + profileID
# 		And header Content-Type = 'application/json'
# 		And profile.company.assets = 123.45
# 		And profile.company.annual_income = 1000.01
# 		And request profile
# 		When method PATCH
# 		Then assert responseStatus == 200
# 		And assert response.company.assets == 123.45
# 		And assert response.company.annual_income == 1000.01

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "18751-152",
# 			street: "Rua Maria Eugênia",
# 			number: "4567",
# 			complement: "Perto da sorveteria",
# 			neighborhood: "Paraíso",
# 			city: "São Paulo",
# 			state_code: "SP",
# 			country_code: "BRA"
# 			}
# 			"""

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def document = call createDocument { type: 'CORPORATE_DOCUMENT'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('../_data/document_sample.jpg')

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def shareholder =  call createShareholder { document_number: '#(CPFGenerator())', percent: 95.0, offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}
# 		* shareholder.date_of_birth = "01/01/2000"
# 		* shareholder.person_type = "INDIVIDUAL"
# 		* shareholder.level = 1

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/shareholders'
# 		And request shareholder
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/override'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/override.js')
# 		And def override = call func { entityID : '#(profileID)' , ruleSet: "SERASA_BUREAU" , ruleName: "CUSTOMER_HAS_PROBLEMS_IN_SERASA" , result : "#(RuleResult.Approved)" }
# 		And request override
# 		When method POST
# 		Then assert responseStatus == 200
		
# 		* def legaRepresentative = call createLegalRepresentative { document_number: '#(CPFGenerator())', offer_type: '#(OfferType.MaquininhaPortal)', partner_id: '#(PartnerID.BexsBanco)'}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/legal-representative'
# 		And header Content-Type = 'application/json'
# 		And request legaRepresentative
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legalRepresentativeID = response.legal_representative_id

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200
# 		And assert response.detailed_result[0].details[0].code == "LEGAL_REPRESENTATIVE_NOT_APPROVED"

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Incomplete
# 		And path '/state/' + legalRepresentativeID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(legalRepresentativeID)', result: '#(RuleResult.Incomplete)' }
# 		And match response.rule_set_result contains { step_number: 0, set: '#(RuleResult.Incomplete)', name: 'DOCUMENT_NOT_FOUND', result: '#(RuleResult.Incomplete)', pending: false, metadata: '##notnull', problems: '##notnull'}


