# @parallel=false
# Feature: Underage Rule

# 	Background:
# 		* def createPartner = read('../_data/testPartner.js')
# 		* def catalogID = '4c3720f2-c1e5-5f99-b9d3-93ca51abac3d'
# 		* def maiorIdade = "1992-07-10T00:00:00Z"
# 		* def menorIdade = "2020-07-10T00:00:00Z"
# 		* def createProfileIndividual = read('../_data/profileIndividual.js')

# 		* def partner = call createPartner { id: "cd7a5cdc-5a8e-42ad-91c5-4505585215bb", name: "TEST_Underage_RULE", document_number: "7596871111", segregation_type: "BY_PARTNER", use_callback_v2: true }

# 		Given url registrationUrlInt
# 		And path '/partners'
# 		And header Content-Type = 'application/json'
# 		And request partner
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 		* def TEST_Underage_RULE_partner = response.partner_id
# 		* def offer = { offer_type : 'TEST_Underage_RULE_enrich', product: 'maquininha'}

# 		Given url registrationUrlInt
# 		And path '/offers'
# 		And header Content-Type = 'application/json'
# 		And request offer
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 		* def TEST_Underage_Enrich_offer = response.offer_type

# 		Given url complianceUrlInt
# 		And path '/catalogs/' + catalogID
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/singleLevelCatalogForConfig.js')
# 		And def catalogCompany = call func { offer_type: '#(TEST_Underage_Enrich_offer)', role_type: 'CUSTOMER', profile_type: 'INDIVIDUAL', account_flag: false, enrich_Profile: true, rulesConfig : { under_age_params: {}} }
# 		And request catalogCompany
# 		When method PUT
# 		Then assert responseStatus == 200


# Scenario: Client registered as a minor, enriched as a major, when validated as a minor, must be approved

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(TEST_Underage_RULE_partner)', document_number: '#(documentNumber)', offer_type: '#(TEST_Underage_Enrich_offer)', role_type: 'CUSTOMER'}

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And profile.individual.date_of_birth = menorIdade
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Approved)' }

# Scenario: Customer registered as an adult, enriched as an adult, when validated with underage, must be approved

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(TEST_Underage_RULE_partner)', document_number: '#(documentNumber)', offer_type: '#(TEST_Underage_Enrich_offer)', role_type: 'CUSTOMER'}

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And profile.individual.date_of_birth = maiorIdade
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Approved)' }

# Scenario: Customer registered as an adult, enriched as a minor, when validated with underage, must be rejected

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(TEST_Underage_RULE_partner)', document_number: '#(documentNumber)', offer_type: '#(TEST_Underage_Enrich_offer)', role_type: 'CUSTOMER'}

# 		Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-regular-minor"}
#         When method POST
#         Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And profile.individual.date_of_birth = maiorIdade
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Rejected)' }

# Scenario: Customer registered as a minor, enriched as a minor, when validated with underage, must be rejected

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(TEST_Underage_RULE_partner)', document_number: '#(documentNumber)', offer_type: '#(TEST_Underage_Enrich_offer)', role_type: 'CUSTOMER'}

# 		Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-regular-minor"}
#         When method POST
#         Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And profile.individual.date_of_birth = menorIdade
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Rejected)' }

# Scenario: Client registered as an adult, not enriched, when being validated with underage, it has to be approved

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(TEST_Underage_RULE_partner)', document_number: '#(documentNumber)', offer_type: '#(TEST_Underage_Enrich_offer)', role_type: 'CUSTOMER'}

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And profile.individual.date_of_birth = maiorIdade
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Approved)' }

# Scenario: Customer registered as a minor, not enriched, when being validated with underage, it has to be rejected

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(TEST_Underage_RULE_partner)', document_number: '#(documentNumber)', offer_type: '#(TEST_Underage_Enrich_offer)', role_type: 'CUSTOMER'}
# 		Given url bureauMockUrl
#         And path '/mock/' + documentNumber
#         And header Content-Type = 'application/json'
#         And request {"mock_name": "cpf-regular-minor"}
#         When method POST
#         Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And profile.individual.date_of_birth = menorIdade
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Rejected)' }


