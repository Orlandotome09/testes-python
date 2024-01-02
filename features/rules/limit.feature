# @parallel=false
# Feature: Limit rule

# 	Background:
# 		* url registrationUrlInt
# 		* def limit = read('../_data/limit.js')

# 	Scenario: Sync Limit assigned in Limit and FX_Integrator

# 		* def profileDocumentNumber = CNPJGenerator()
# 		* def documentNormalized = DocumentNormalizer(profileDocumentNumber)

# 		Given url bureauMockUrl
# 		And path '/mock/'+ documentNormalized
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-regular"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/profileCompany.js')
# 		And def profile = call func { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(profileDocumentNumber)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
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
# 		And  assert response.company.assets == 123.45
# 		And  assert response.company.annual_income == 1000.01

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/legal-representative'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/legalRepresentative.js')
# 		And def documentNumber = CPFGenerator()
# 		And def dataLegal = call func { document_number: '#(documentNumber)',offer_type: 'MAQUININHA_01',partner_id: '#(PartnerID.OpenSolo)'}
# 		And request dataLegal
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legalRepresentativeID = response.legal_representative_id
# 		* def legalRepresentativeDocument = response.document_number

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

# 		* def documentsFileId = response.document_file_id

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

# 		* def addressID = response.address_id

# 		# PROFILE IS ANALSING SINCE LR WAS NOT APPROVED
# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		When method GET
# 		Then assert responseStatus == 200

# 		# PROFILE HAS NO LIMIT YET
# 		Given url limitUrlInt
# 		And path '/profile/' +profileID
# 		When method GET
# 		And assert responseStatus == 404

# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID
# 		And header Content-Type = 'application/json'
# 		And request dataLegal
# 		When method PATCH
# 		Then assert responseStatus == 200


# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID + '/document'
# 		And header Content-Type = 'application/json'
# 		And def document = read('../_data/documentByTypeAndSubtype.js')
# 		And def data = call document { type : "IDENTIFICATION", sub_type : "RG"}
# 		And request data
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legaldocumentID = response.document_id

# 		Given path '/file'
# 		And param document_id = legaldocumentID
# 		And multipart file myFile = { filename: 'pdf_sample_4mb.jpg', contentType: 'image/pdf' }
# 		And def file = read('../_data/pdf_sample_4mb.pdf')
# 		And request file
# 		When method POST
# 		Then assert responseStatus == 201

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200
# 		And  assert response.result == RuleResult.Approved

# 		# Profile should be eligible for Custom Limit
# 		Given url limitUrlInt
# 		And path '/profile/' +profileID
# 		And retry until karate.get ('response.custom_limit_eligibility.length') == 1
# 		When method GET
# 		And assert responseStatus == 200
# 		And assert response.custom_limit_eligibility.length == 1
# 		And match response.custom_limit_eligibility contains deep { operation_type : "GENERAL", eligible: true, pending: true }

# 		* def endDate = funcNow(1)
# 		* def limitRequest = call limit { profile_id: '#(profileID)', operation_type: "GENERAL", end_date: '#(endDate)', amount: 2000000 }

# 		Given url limitUrlInt
# 		And path '/periodic/'
# 		And request limitRequest
# 		When method POST
# 		And assert responseStatus == 201

# 		# Limit should be assigned in FX system as well
# 		Given url fxIntegratorUrlInt
# 		And path '/limit'
# 		And param document_number = documentNormalized
# 		And param partner_id = PartnerID.OpenSolo
# 		And param offer_id = OfferType.MaquininhaAPI
# 		When method GET
# 		And assert responseStatus == 200
# 		And match response contains deep { amount: 2000000, operation_type : "GENERAL", limit_type : "CUSTOM", author: '#(limitRequest.author)', comments: '#(limitRequest.comments)'}

# 		# Custom limit assigned
# 		Given url limitUrlInt
# 		And path '/profile/' + profileID
# 		And retry until karate.get ('response.custom_limit_eligibility[0].pending') == false
# 		When method GET
# 		And assert responseStatus == 200
# 		And match response.custom_limit_eligibility contains deep { operation_type : "GENERAL", pending: false }

# 		# Profile should have Custom Limit assigned
# 		Given url limitUrlInt
# 		And path '/periodic'
# 		And param profile_id = profileID
# 		When method GET
# 		And assert responseStatus == 200
# 		And match response contains deep { profile_id: '#(profileID)', amount: 2000000, operation_type : "GENERAL", periodic_limit_type : "CUSTOM" }

# 		* def catalogId = "19978132-9bb4-5205-aa2f-eb8ee02f2c6b"

# 		Given url complianceUrlInt
# 		And path '/profile/' + profileID
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.person.document_number == documentNormalized
# 		And assert response.person.enriched_information.ownership_structure.final_beneficiaries_count == 4
# 		And assert response.person.company.company_registration_number == "56789"
# 		And assert response.person.enriched_information.status == "REGULAR"
# 		And assert response.person.addresses[0].address_id == addressID
# 		And assert response.person.documents[0].document_id == documentID
# 		And assert response.person.catalog.catalog_id == catalogId


# 	Scenario: duplicate limit in fx_integrator

# 		* def profileDocumentNumber = CNPJGenerator()
# 		* def documentNormalized = DocumentNormalizer(profileDocumentNumber)

# 		Given url bureauMockUrl
# 		And path '/mock/'+ documentNormalized
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-regular"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/profileCompany.js')
# 		And def profile = call func { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(profileDocumentNumber)', offer_type: '#(OfferType.MaquininhaAPI)', role_type: 'CUSTOMER'}
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
# 		And  assert response.company.assets == 123.45
# 		And  assert response.company.annual_income == 1000.01

# 		Given url registrationUrlInt
# 		And path '/profile/' + profileID + '/legal-representative'
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/legalRepresentative.js')
# 		And def documentNumber = CPFGenerator()
# 		And def dataLegal = call func { document_number: '#(documentNumber)',offer_type: 'MAQUININHA_01',partner_id: '#(PartnerID.OpenSolo)'}
# 		And request dataLegal
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def legalRepresentativeID = response.legal_representative_id

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

# 		# PROFILE IS ANALSING SINCE LR WAS NOT APPROVED
# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		When method GET
# 		Then assert responseStatus == 200

# 		# PROFILE HAS NO LIMIT YET
# 		Given url limitUrlInt
# 		And path '/profile/' +profileID
# 		When method GET
# 		And assert responseStatus == 404

# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID
# 		And header Content-Type = 'application/json'
# 		And request dataLegal
# 		When method PATCH
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/legal-representative/' + legalRepresentativeID + '/document'
# 		And header Content-Type = 'application/json'
# 		And def document = read('../_data/documentByTypeAndSubtype.js')
# 		And def data = call document { type : "IDENTIFICATION", sub_type : "RG"}
# 		And request data
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

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200
# 		And  assert response.result == RuleResult.Approved

# 		# Profile should be eligible for Custom Limit
# 		Given url limitUrlInt
# 		And path '/profile/' +profileID
# 		And retry until karate.get ('response.custom_limit_eligibility.length') == 1
# 		When method GET
# 		And assert responseStatus == 200
# 		And assert response.custom_limit_eligibility.length == 1
# 		And match response.custom_limit_eligibility contains deep { operation_type : "GENERAL", eligible: true, pending: true }

# 		# Limit should be assigned in FX system as well
# 		* def endDate = funcNow(1)
# 		* def limitRequest = call limit { profile_id: '#(profileID)', operation_type: "GENERAL", end_date: '#(endDate)', amount: 2000000 }
# 		* def duplicatelimitRequest =
# 		"""
# 		{
# 			authorship: {
# 				author: "#(limitRequest.author)",
# 				comment: "#(limitRequest.comments)"
# 			},
# 			limit_method: "Assign",
# 			expiration_date: "2023-10-30T09:19:00Z",
# 			limit_key: {
# 				category: 1,
# 				customer_document: "#(documentNormalized)",
# 				offer_id: "#(OfferType.MaquininhaAPI)",
# 				partner_id: "#(PartnerID.OpenSolo)",
# 				operation_type: "GENERAL"
# 			},
# 			profile_id: "#(profileID)",
# 			usd_amount: 2000000
# 		}
# 		"""

# 		Given url fxIntegratorUrlInt
# 		And path '/limit'
# 		And header Content-Type = 'application/json'
# 		And request duplicatelimitRequest
# 		When method POST
# 		And assert responseStatus == 202

# 		* def endDate = funcNow(1)

# 		Given url limitUrlInt
# 		And path '/periodic/'
# 		And request limitRequest
# 		When method POST
# 		And assert responseStatus == 500

# 		# Custom limit assigned
# 		Given url limitUrlInt
# 		And path '/profile/' + profileID
# 		When method GET
# 		And assert responseStatus == 200
# 		And match response.custom_limit_eligibility contains deep { operation_type : "GENERAL", pending: true }

# 		# Profile should have Custom Limit assigned
# 		Given url limitUrlInt
# 		And path '/periodic'
# 		And param profile_id = profileID
# 		When method GET
# 		And assert responseStatus == 200
# 		And assert response.length == 0
