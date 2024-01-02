# @parallel=false
# Feature: Bureau Rule

#     Background:
#         * def getPendingFlagForRule = function(rulesResults,ruleName){ var temp = karate.filter(rulesResults, function(x){ return x.name == ruleName }); return temp[0].pending }
#         * def createPartner = read('../_data/testPartner.js')
#         * def catalogIDIndividual = '4ba42456-c081-59ce-b315-438d4ee14c05'
#         * def catalogIDCompany = 'c0dc4880-ac75-595c-a4c7-f1a169d82457'
#         * def catalogIDIMerchant = '94297f87-198b-52a8-b03e-4020f066cfa0'

#         * def partner = call createPartner { id: "1113d8e5-1e56-5cdd-a7b6-9eee5372a111", name: "TESTE_BUREAU_RULE", document_number: "123456", segregation_type: "BY_PARTNER", use_callback_v2: true }

#         Given url registrationUrlInt
#         And path '/partners'
#         And header Content-Type = 'application/json'
#         And request partner
#         When method POST
#         Then assert responseStatus == 201 || responseStatus == 409

#         * def bureauPartner = response.partner_id
#         * def offer = { offer_type : 'TESTE_BUREAU_RULE', product: 'Test'}

#         Given url registrationUrlInt
#         And path '/offers'
#         And header Content-Type = 'application/json'
#         And request offer
#         When method POST
#         Then assert responseStatus == 201 || responseStatus == 409

#         * def bureauOffer = response.offer_type

#         Given url complianceUrlInt
#         And path '/catalogs/' + catalogIDCompany
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/singleLevelCatalogForConfig.js')
#         And def catalogCompany = call func { offer_type: '#(bureauOffer)', role_type: 'CUSTOMER', profile_type: 'COMPANY', account_flag: false, rulesConfig :{ bureau_params: { approved_statuses: ['PENDING_REGULARIZATION']} } , step_number: 0}
#         And request catalogCompany
#         When method PUT
#         Then assert responseStatus == 200

#         Given path '/catalogs/' + catalogIDIndividual
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/singleLevelCatalogForConfig.js')
#         And def catalogIndividual = call func { offer_type: '#(bureauOffer)', role_type: 'CUSTOMER', profile_type: 'INDIVIDUAL', account_flag: false, rulesConfig :{ bureau_params: { approved_statuses: ['PENDING_REGULARIZATION']} }, step_number: 0}
#         And request catalogIndividual
#         When method PUT
#         Then assert responseStatus == 200

#         Given path '/catalogs/' + catalogIDIMerchant
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/singleLevelCatalogForConfig.js')
#         And def catalogMerchant = call func { offer_type: '#(bureauOffer)', role_type: 'MERCHANT', profile_type: 'COMPANY', account_flag: false, rulesConfig : null , step_number: 0}
#         And request catalogMerchant
#         When method PUT
#         Then assert responseStatus == 200

#     Scenario: Should Profile Individual pending settlement in serasa/serpro

#         * def documentNumber = CPFGenerator()

#         Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-pending"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url bureauURL + "/person/" + documentNumber
#         And header offer-origin = "investments"
#         And header partner-origin = "YYYYY"
#         When method GET
#         Then assert responseStatus == 200
#         And  match response contains deep { cadastral_situation: {value: {situation: "PENDENTE DE REGULARIZACAO", situation_code: 2}}, name: {value: "FULANO DOS MOCKS"}, personal_id: {value: '#(documentNumber)'}, address: "##notnull", birth_date : {value : "23/11/1992"} }

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileIndividual.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNumber)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And retry until karate.get ('response.result') == RuleResult.Approved
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 200
#         And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Approved)' }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_NOT_FOUND_IN_SERASA', result: '#(RuleResult.Approved)', pending: false, metadata: null }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_HAS_PROBLEMS_IN_SERASA', result: '#(RuleResult.Approved)', pending: false, metadata: null }

#         Given url complianceUrlInt
#         And path '/profile/' + profileID
#         When method GET
#         Then assert responseStatus == 200
#         Then assert response.person.document_number == documentNumber
#         And match response.person.enriched_information contains { status: "PENDING_REGULARIZATION", name: "FULANO DOS MOCKS", birth_date: "23/11/1992"}

#     Scenario: Should Profile Individual Regular in serasa/serpro

#         * def documentNumber = CPFGenerator()

#         Given url bureauURL + "/person/" + documentNumber
#         And header offer-origin = "investments"
#         And header partner-origin = "YYYYY"
#         When method GET
#         Then assert responseStatus == 200
#         And  match response contains deep { cadastral_situation: {value: {situation: "REGULAR", situation_code: 1}}, name: {value: "FULANO DOS MOCKS"}, personal_id: {value: '#(documentNumber)'}, address: "##notnull", birth_date : {value : "23/11/1992"} }

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileIndividual.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNumber)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And retry until karate.get ('response.result') == RuleResult.Approved
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 200
#         And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Approved)' }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_NOT_FOUND_IN_SERASA', result: '#(RuleResult.Approved)', pending: false, metadata: null }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_HAS_PROBLEMS_IN_SERASA', result: '#(RuleResult.Approved)', pending: false, metadata: null }

#     Scenario: Should profile is not created in compliance because the serpro ip is disabled


#         * def documentNumber = CPFGenerator()

#         Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-disabled-ip"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileIndividual.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNumber)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 404


#         * def validationError =
#         """
#             {
#                 "code": 500,
#                 "name": "Internal Server Error"
#             }

#         """
    
#         Given url bureauURL + "/person/" + documentNumber
#         And header offer-origin = "investments"
#         And header partner-origin = "YYYYY"
#         When method GET
#         Then assert responseStatus == 500
#         And  match response contains validationError
       
#     Scenario: Should Profile Individual not found on serasa/serpro

#         * def documentNumber = CPFGenerator()

#         Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-not-found"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileIndividual.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNumber)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And retry until karate.get ('response.result') == RuleResult.Rejected
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 200
#         And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Rejected)' }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_NOT_FOUND_IN_SERASA', result: '#(RuleResult.Rejected)', pending: false, metadata: null, problems: "##notnull"}
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_HAS_PROBLEMS_IN_SERASA', result: 'IGNORED', pending: false, metadata: null }

#     Scenario: Should Profile Individual irregular in serasa/serpro


#         * def documentNumber = CPFGenerator()

#         Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-canceled"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileIndividual.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNumber)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And retry until karate.get ('response.result') == RuleResult.Rejected
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 200
#         And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Rejected)' }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_NOT_FOUND_IN_SERASA', result: 'APPROVED', pending: false, metadata: null }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_HAS_PROBLEMS_IN_SERASA', result: '#(RuleResult.Rejected)', pending: false, metadata: '##notnull', problems: '##notnull'}

#     Scenario: Should Profile Company Regular in serasa/serpro

#         * def profileDocumentNumber = CNPJGenerator()
#         * def documentNormalized = DocumentNormalizer(profileDocumentNumber)

#         Given url bureauMockUrl
#         And path '/mock/' + documentNormalized
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cnpj-regular"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileCompany.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNormalized)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And retry until karate.get ('response.result') == RuleResult.Approved
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 200
#         And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Approved)' }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_NOT_FOUND_IN_SERASA', result: '#(RuleResult.Approved)', pending: false, metadata: null }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_HAS_PROBLEMS_IN_SERASA', result: '#(RuleResult.Approved)', pending: false, metadata: null }

#     Scenario: Should Profile company complete and irregular in serasa/serpro


#         * def profileDocumentNumber = CNPJGenerator()
#         * def documentNormalized = DocumentNormalizer(profileDocumentNumber)

#         Given url bureauMockUrl
#         And path '/mock/' + documentNormalized
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cnpj-removed"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileCompany.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNormalized)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And retry until karate.get ('response.result') == RuleResult.Rejected
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 200
#         And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Rejected)' }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_NOT_FOUND_IN_SERASA', result: '#(RuleResult.Approved)', pending: false, metadata: null }
#         And match response.rule_set_result contains { step_number: 0, set: 'SERASA_BUREAU', name: 'CUSTOMER_HAS_PROBLEMS_IN_SERASA', result: '#(RuleResult.Rejected)', pending: false, metadata: '##notnull', problems: '##notnull'}

#     Scenario: Should Profile Company customer not found on serasa/serpro

#         * def profileDocumentNumber = CNPJGenerator()
#         * def documentNormalized = DocumentNormalizer(profileDocumentNumber)

#         Given url bureauMockUrl
#         And path '/mock/' + documentNormalized
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cnpj-not-found"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url bureauURL + "/entity/" + documentNormalized
#         And header offer-origin = "investments"
#         And header partner-origin = "YYYYY"
#         And param required_fields = "cnae"
#         When method GET
#         Then assert responseStatus == 404
#         And  def expected = "Legal Entity with id "+documentNormalized+" not found on Bureau"
#         And  match response contains deep { description: '#(expected)' }

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileCompany.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', document_number: '#(documentNormalized)', offer_type: '#(bureauOffer)', role_type: 'CUSTOMER'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         * def profileID = response.profile_id

#         Given url complianceUrlInt
#         And retry until karate.get ('response.result') == RuleResult.Rejected
#         And path '/state/' + profileID
#         And header Content-Type = 'application/json'
#         When method GET
#         Then assert responseStatus == 200
#         And match response contains { entity_id: '#(profileID)', engine_name: 'PROFILE', result: '#(RuleResult.Rejected)' }
#         And match response contains deep { rule_set_result: [{name: "CUSTOMER_NOT_FOUND_IN_SERASA", result: "#(RuleResult.Rejected)"}] }

#     Scenario: Should Merchant not found in bureau Bug 1819

#         * def profileDocumentNumber = CNPJGenerator()
#         * def documentNormalized = DocumentNormalizer(profileDocumentNumber)

#         Given url registrationUrlInt
#         And path '/profile'
#         And header Content-Type = 'application/json'
#         And def func = read('../_data/profileCompany.js')
#         And def profile = call func { partner_id: '#(bureauPartner)', callback_url: '#(callbackURL)', document_number: '#(documentNormalized)', offer_type: '#(bureauOffer)', role_type: 'MERCHANT'}
#         And request profile
#         When method POST
#         Then assert responseStatus == 201

#         Given url bureauMockUrl
#         And path '/mock/' + documentNormalized
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cnpj-not-found"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url bureauMockUrl
#         And path '/mock/' + documentNormalized
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cnpj-not-found"}
#         When method POST
#         Then assert responseStatus == 200

#         Given url temis_enrichment
#         And path '/legal-entity/' + documentNormalized
#         And header Offer-Type = bureauOffer
#         And header Partner-Id = bureauPartner
#         When method GET
#         Then assert responseStatus == 204