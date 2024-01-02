# @parallel=false
# Feature: Incomplete Rule

# 	Background:
# 		* url registrationUrlInt
# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def createProfileCustomerCompany = read('../_data/profileCompany.js')

# 		* def offer = { offer_type : 'TEST_INCOMPLETE_RULE_COMPANY', product: 'maquininha'}

# 		Given url registrationUrlInt
# 		And path '/offers'
# 		And header Content-Type = 'application/json'
# 		And request offer
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 		* def incompleteOFFER = response.offer_type

# 		Given url complianceUrlInt
# 		And path '/catalogs'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/incomplete.js')
# 		And def catalogCompany = call func { offer_type: '#(incompleteOFFER)', role_type: 'CUSTOMER', profile_type: 'COMPANY', account_flag: false}
# 		And request catalogCompany
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 	Scenario: Should approve cooperative with required documents

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(incompleteOFFER)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/'+ documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cooperative-empty-directors"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And def func = read('../_data/documentByType.js')
# 		And def document = call func { type: 'CORPORATE_DOCUMENT'}
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given path '/profile/' + profileID + '/document'
# 		And header Content-Type = 'application/json'
# 		And def document = read('../_data/documentByTypeAndSubtype.js')
# 		And def data = call document { type : "APPOINTMENT_DOCUMENT", sub_type : "MINUTES_OF_ELECTION"}
# 		And request data
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID1 = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID1
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given path '/profile/' + profileID + '/document'
# 		And header Content-Type = 'application/json'
# 		And def document = read('../_data/documentByTypeAndSubtype.js')
# 		And def data = call document { type : "CONSTITUTION_DOCUMENT", sub_type : "STATUTE_SOCIAL"}
# 		And request data
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID1 = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID1
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "13221-111",
# 			street: "Rua Maria Eugênia",
# 			number: "485",
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

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Approved
# 		And match response.rule_set_result contains deep { set:"#(RuleResult.Incomplete)", name:"DOCUMENT_NOT_FOUND",result:"#(RuleResult.Approved)", pending: false }
		
# 	Scenario:  Should leave as INCOMPLETE cooperative without required STATUTE_SOCIAL and  MINUTES_OF_ELECTION documents

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(incompleteOFFER)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/'+ documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cooperative-empty-directors"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And def func = read('../_data/documentByType.js')
# 		And def document = call func { type: 'CORPORATE_DOCUMENT'}
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "13221-111",
# 			street: "Rua Maria Eugênia",
# 			number: "485",
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

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Incomplete
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Incomplete
# 		And match response.rule_set_result contains deep { set:"#(RuleResult.Incomplete)", name:"DOCUMENT_NOT_FOUND",result:"#(RuleResult.Incomplete)", pending: false }
		
# 	Scenario: Should leave as INCOMPLETE cooperative without required STATUTE_SOCIAL document

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(incompleteOFFER)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/'+ documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cooperative-empty-directors"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And def func = read('../_data/documentByType.js')
# 		And def document = call func { type: 'CORPORATE_DOCUMENT'}
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "13221-111",
# 			street: "Rua Maria Eugênia",
# 			number: "485",
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

# 		Given path '/profile/' + profileID + '/document'
# 		And header Content-Type = 'application/json'
# 		And def document = read('../_data/documentByTypeAndSubtype.js')
# 		And def data = call document { type : "APPOINTMENT_DOCUMENT", sub_type : "MINUTES_OF_ELECTION"}
# 		And request data
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID1 = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID1
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Incomplete
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Incomplete
# 		And match response.rule_set_result contains deep { set:"#(RuleResult.Incomplete)", name:"DOCUMENT_NOT_FOUND",result:"#(RuleResult.Incomplete)", pending: false }
		
# 	Scenario: Should leave as INCOMPLETE cooperative without required MINUTES_OF_ELECTION document

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(incompleteOFFER)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/'+ documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cooperative-empty-directors"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/document'
# 		And def func = read('../_data/documentByType.js')
# 		And def document = call func { type: 'CORPORATE_DOCUMENT'}
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "13221-111",
# 			street: "Rua Maria Eugênia",
# 			number: "485",
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

# 		Given path '/profile/' + profileID + '/document'
# 		And header Content-Type = 'application/json'
# 		And def document = read('../_data/documentByTypeAndSubtype.js')
# 		And def data = call document { type : "CONSTITUTION_DOCUMENT", sub_type : "STATUTE_SOCIAL"}
# 		And request data
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID1 = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID1
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Incomplete
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Incomplete
# 		And match response.rule_set_result contains deep { set:"#(RuleResult.Incomplete)", name:"DOCUMENT_NOT_FOUND",result:"#(RuleResult.Incomplete)", pending: false }
		
# 	Scenario: Should approve public company without MINUTES_OF_ELECTION and STATUTE_SOCIAL documents

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(incompleteOFFER)', role_type: 'CUSTOMER'}}
# 		* profile.company.legal_nature = "2011"

# 		Given url registrationUrlInt 
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url registrationUrlInt
# 		And path '/profile/'+profileID+'/document'
# 		And def func = read('../_data/documentByType.js')
# 		And def document = call func { type: 'CORPORATE_DOCUMENT'}
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id

# 		Given path '/file'
# 		And param document_id = documentID
# 		And multipart file myFile = { filename: 'document_sample.jpg', contentType: 'image/jpeg' }
# 		And def file = read('../_data/document_sample.jpg')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "13221-111",
# 			street: "Rua Maria Eugênia",
# 			number: "485",
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

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Approved
# 		And match response.rule_set_result contains deep { set:"#(RuleResult.Incomplete)", name:"DOCUMENT_NOT_FOUND",result:"#(RuleResult.Approved)", pending: false }

# 	Scenario: Should leave as INCOMPLETE public company without required CORPORATE_DOCUMENTS document

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(incompleteOFFER)', role_type: 'CUSTOMER'}}
# 		* profile.company.legal_nature = "2011"

# 		Given url registrationUrlInt 
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id


# 		* def address =
# 			"""
# 			{
# 			type: "LEGAL",
# 			zip_code: "13221-111",
# 			street: "Rua Maria Eugênia",
# 			number: "485",
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

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Incomplete
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Incomplete
# 		And match response.rule_set_result contains deep { set:"#(RuleResult.Incomplete)", name:"DOCUMENT_NOT_FOUND",result:"#(RuleResult.Incomplete)", pending: false }