# @parallel=false
# Feature: Director Rule

# 	Background:
# 		* url registrationUrlInt
# 		* def createProfileCustomerCompany = read('../_data/profileCompany.js')
# 		* def diretor = read('../_data/director.js')
# 		* def documentNumberCompany = DocumentNormalizer(CNPJGenerator())
# 		* def documentNumberIndividual = DocumentNormalizer(CPFGenerator())

# 	#Default Diretor BRA
# 	Scenario: Should Approve profile with registered board of director

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
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

# 		* def diretorMaquininha1 =  call diretor { name: "Joseph", document_number: "#(CPFGenerator())", date_of_birth: "1980-01-01"}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha1
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID1 = response.director_id

# 		Given path '/director/' + directorID1
# 		When method GET
# 		Then assert responseStatus == 200

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
# 		And path '/director/' + directorID1 + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def addressID1 = response.address_id

# 		* def diretorMaquininha2 =  call diretor { name: "Test", document_number: "#(CPFGenerator())", date_of_birth: "1980-01-02"}

# 		Given path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha2
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID2 = response.director_id

# 		Given path '/director/' + directorID2
# 		When method GET
# 		Then assert responseStatus == 200

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Approved
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Approved)", pending: false }

# 		Given path '/state/' + directorID1
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		And match response.rule_set_result contains deep { set:"SERASA_BUREAU", name:"CUSTOMER_NOT_FOUND_IN_SERASA",result:"#(RuleResult.Approved)", pending: false }

# 		Given path '/state/' + directorID2
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		And match response.rule_set_result contains deep { set:"SERASA_BUREAU", name:"CUSTOMER_NOT_FOUND_IN_SERASA",result:"#(RuleResult.Approved)", pending: false }

# 		Given url temis_query
# 		And path '/profile/' + profileID
# 		And retry until karate.get('response.directors[0].addresses[0].address_id') == addressID1
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains deep { directors: [{ addresses: [{ address_id: "#(addressID1)" }]}]}

# 	Scenario: Should create an Approved profile with the board of directors Ignored because it is different from codes 2143,2046,1210,3204,3212,3999

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}}

# 		Given path '/profile'
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
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"IGNORED", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"IGNORED", pending: false }

# 	Scenario: Should leave profile as ANALYSING when registered board of director is not approved

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
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

# 		Given path '/profile/'+profileID+'/document'
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

# 		Given path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def diretorMaquininha =  call diretor { name: "Joseph", document_number: "#(documentNumberIndividual)", date_of_birth: "1980-01-01"}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberIndividual
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cpf-canceled"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID = response.director_id

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + directorID
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response.rule_set_result contains deep { set:"SERASA_BUREAU", name:"CUSTOMER_HAS_PROBLEMS_IN_SERASA", result:"REJECTED", pending: false }

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Rejected
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Rejected)", pending: false }

# 	Scenario: Should Approve profile with enrichment board of director

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/'+ documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cooperative"}
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

# 		Given url complianceUrlInt
# 		And path '/profile/' + profileID
# 		And retry until karate.get ('response.person.enriched_information.status') == "REGULAR"
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response.person.enriched_information contains deep { status:"REGULAR", legal_nature:"2143"}
# 		And match response.person.enriched_information.board_of_directors[0].person contains deep { person_type:"INDIVIDUAL", entity_type:"DIRECTOR"}

# 		* def directorID1 = response.person.enriched_information.board_of_directors[0].director_id

# 		Given path '/state/' + directorID1
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		And match response.rule_set_result contains deep { set:"SERASA_BUREAU", name:"CUSTOMER_NOT_FOUND_IN_SERASA",result:"#(RuleResult.Approved)", pending: false }

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Approved
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Approved)", pending: false }


# 	Scenario: Should Approve profile with enrichment board of director and registred board of director

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cooperative"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given path '/profile/'+profileID+'/document'
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

# 		Given path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def diretorMaquininha =  call diretor { name: "Joseph", document_number: "#(documentNumberIndividual)", date_of_birth: "1980-01-01"}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberIndividual
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cpf-canceled"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID = response.director_id

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Approved
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Approved)", pending: false }

# 		# Validate registred of director

# 		Given url complianceUrlInt
# 		And path '/profile/' + profileID
# 		When method GET
# 		Then assert responseStatus == 200
# 		And assert response.board_of_directors[0].director_id == directorID

# 	Scenario: Should leave profile as Analysing when enrichement board of director is not approved

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		* def documentMock = "32089573007"

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentMock
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cpf-canceled"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cooperative-canceled-directors"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given path '/profile/'+profileID+'/document'
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

# 		Given path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* sleep(2000)


# 		Given url complianceUrlInt
# 		And path '/profile/' + profileID
# 		And retry until karate.get ('response.person.enriched_information.board_of_directors.length') >= 2
# 		When method GET
# 		Then assert responseStatus == 200

# 		* def directorID = response.person.enriched_information.board_of_directors[1].director_id

# 		Given path '/state/' + directorID
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		And match response.rule_set_result contains deep { set:"SERASA_BUREAU", name:"CUSTOMER_HAS_PROBLEMS_IN_SERASA",result:"#(RuleResult.Rejected)", pending: false }

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Rejected
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Rejected)", pending: false }

# 	Scenario: Should ignore board of directors rule when enriched legal nature does not correspond to a company with directors

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-removed"}
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

# 		* def diretorMaquininha1 =  call diretor { name: "Joseph", document_number: "#(CPFGenerator())", date_of_birth: "1980-01-01"}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha1
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID1 = response.director_id

# 		Given path '/director/' + directorID1
# 		When method GET
# 		Then assert responseStatus == 200

# 		* def diretorMaquininha2 =  call diretor { name: "Test", document_number: "#(CPFGenerator())", date_of_birth: "1980-01-02"}

# 		Given path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha2
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID2 = response.director_id

# 		Given path '/director/' + directorID2
# 		When method GET
# 		Then assert responseStatus == 200

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Rejected
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"IGNORED", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"IGNORED", pending: false }

# 	Scenario: Should profile Analysing with registered board of director present in Watchlist

# 		* def WatchlistBody = { document_number: "#(documentNumberIndividual)", title:"SomeToken", name: "Someone", link: "/link", watch: "", other: "", entries: ["someEntry"], sources: ["ADVERSE_MEDIA"]}
# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
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

# 		Given url temis_mock
# 		And path '/compliance/watchlist'
# 		And request WatchlistBody
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def validationBody = { title:"SomeToken", name: "Someone", link: "/link", watch: "", other: "", entries: ["someEntry"], sources: ["ADVERSE_MEDIA"]}

# 		Given url temis_mock
# 		And path '/compliance/watchlist/' + documentNumberIndividual
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains validationBody

# 		* def diretorMaquininha1 =  call diretor { name: "Joseph", document_number: "#(documentNumberIndividual)", date_of_birth: "1980-01-01"}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha1
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID1 = response.director_id

# 		Given path '/director/' + directorID1
# 		When method GET
# 		Then assert responseStatus == 200

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + directorID1
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Analysing
# 		And match response.rule_set_result contains deep { set:"WATCHLIST", name:"WATCHLIST",result:"#(RuleResult.Analysing)", pending: true }

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Analysing
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Analysing)", pending: true }

# 	# Foreign Director
# 	Scenario: Should foreign director registred with CPF restriction AND profile with status analysing

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
# 		* profile.company.legal_nature = "2143"

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberCompany
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

# 		Given path '/profile/'+profileID+'/document'
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

# 		Given path '/profile/' + profileID + "/address"
# 		And request address
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def diretorMaquininha =  call diretor { name: "Joseph", document_number: "#(documentNumberIndividual)", date_of_birth: "1980-01-01", nationality: "USA"}

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumberIndividual
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cpf-canceled"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID = response.director_id

# 		Given path '/director/' + directorID
# 		When method GET
# 		Then assert responseStatus == 200
# 		And assert response.nationality == "USA"

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + directorID
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		And match response.rule_set_result contains deep { set:"SERASA_BUREAU", name:"CUSTOMER_HAS_PROBLEMS_IN_SERASA",result:"#(RuleResult.Rejected)", pending: false }

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Rejected
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Rejected)", pending: false }

# 	Scenario: Should Approve profile with registered board of director AND nationality foreign

# 		* def profile = call createProfileCustomerCompany { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberCompany)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
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

# 		* def diretorMaquininha1 =  call diretor { name: "Joseph", document_number: "#(CPFGenerator())", date_of_birth: "1980-01-01", nationality: "USA"}

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha1
# 		When method POST
# 		Then assert responseStatus == 201
# 		And assert response.nationality == "USA"

# 		* def directorID1 = response.director_id

# 		Given path '/director/' + directorID1
# 		When method GET
# 		Then assert responseStatus == 200

# 		* def diretorMaquininha2 =  call diretor { name: "Test", document_number: "#(CPFGenerator())", date_of_birth: "1980-01-02"}

# 		Given path '/profile/' + profileID + '/director'
# 		And request diretorMaquininha2
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def directorID2 = response.director_id

# 		Given path '/director/' + directorID2
# 		When method GET
# 		Then assert responseStatus == 200

# 		* sleep(2000)

# 		Given url complianceUrlInt
# 		And path '/state/' + directorID1
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET

# 		Given path '/state/' + directorID2
# 		And header Content-Type = 'application/json'
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Approved
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_COMPLETE",result:"#(RuleResult.Approved)", pending: false }
# 		And match response.rule_set_result contains deep { set:"BOARD_OF_DIRECTORS", name:"BOARD_OF_DIRECTORS_RESULT",result:"#(RuleResult.Approved)", pending: false }