# @parallel=false
# Feature: Hight risk Rule

# 	Background:
# 		* def createPartner = read('../_data/testPartner.js')
# 		* def catalogID = '86c9e79f-f65b-58ab-9ebb-2fd35d3ba480'
# 		* def createProfPJ = read('../_data/profileCompany.js')
# 		* def ruleNameHighRiskActivity = "HIGH_RISK_ACTIVITY"

# 		* def partner = call createPartner { id: "dcf3ecc1-b160-48b7-8936-10b184f8fac8", name: "TESTE_BLACKLIST_RULE", document_number: "123456", segregation_type: "BY_PARTNER", use_callback_v2: true }

# 		Given url registrationUrlInt
# 		And path '/partners'
# 		And header Content-Type = 'application/json'
# 		And request partner
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 		* def TestBlacklistRulePartner = response.partner_id
# 		* def offer = { offer_type : 'Alto_risco', product: 'maquininha'}

# 		Given url registrationUrlInt
# 		And path '/offers'
# 		And header Content-Type = 'application/json'
# 		And request offer
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 		* def AltoRiscoOffer = response.offer_type
		
# 		Given url complianceUrlInt
# 		And path '/catalogs/' + catalogID
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/singleLevelCatalogForConfig.js')
# 		And def catalogCompany = call func { offer_type: '#(AltoRiscoOffer)', role_type: 'CUSTOMER', profile_type: 'COMPANY', account_flag: false, rulesConfig : { activity_risk_params: {} } }
# 		And request catalogCompany
# 		When method PUT
# 		Then assert responseStatus == 200

# 	Scenario: Should find high risk activity

# 		* def documentNumber =  DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfPJ {  partner_id: '#(TestBlacklistRulePartner)', document_number: '#(documentNumber)', offer_type: '#(AltoRiscoOffer)', role_type: 'CUSTOMER' }

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumber
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-cnae-risk"}
# 		When method POST
# 		Then assert responseStatus == 200


# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		When method GET
# 		* def ruleResults = response.rule_set_result
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Analysing
# 		Then assert ruleResults[0].set == "ACTIVITY_RISK"
# 		Then assert ruleResults[0].name == ruleNameHighRiskActivity
# 		Then assert ruleResults[0].result == RuleResult.Analysing

# 	Scenario: Should not find high risk activity

# 		* def documentNumber =  DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfPJ {  partner_id: '#(TestBlacklistRulePartner)', document_number: '#(documentNumber)', offer_type: '#(AltoRiscoOffer)', role_type: 'CUSTOMER' }

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumber
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-regular"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url bureauURL + "/entity/" + documentNumber
# 		And header offer-origin = "investments"
# 		And header partner-origin = "YYYYY"
# 		And param required_fields = "cnae"
# 		When method GET
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		When method GET
# 		* def ruleResults = response.rule_set_result
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Approved
# 		Then assert ruleResults[0].set == "ACTIVITY_RISK"
# 		Then assert ruleResults[0].name == ruleNameHighRiskActivity
# 		Then assert ruleResults[0].result == RuleResult.Approved

# 	Scenario: User not found in the bureau

# 		* def documentNumber =  DocumentNormalizer(CNPJGenerator())
# 		* def profile = call createProfPJ {  partner_id: '#(TestBlacklistRulePartner)', document_number: '#(documentNumber)', offer_type: '#(AltoRiscoOffer)', role_type: 'CUSTOMER' }

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumber
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-not-found"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url bureauMockUrl
# 		And path '/mock/' + documentNumber
# 		And header Content-Type = 'application/json'
# 		And request {"mock_name": "cnpj-not-found"}
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		Given url complianceUrlInt
# 		And path '/state/' + profileID
# 		And retry until karate.get ('response.result') == RuleResult.Rejected
# 		When method GET
# 		* def ruleResults = response.rule_set_result
# 		Then assert responseStatus == 200
# 		Then assert response.result == RuleResult.Rejected
# 		Then assert ruleResults[0].set == "ACTIVITY_RISK"
# 		Then assert ruleResults[0].name == ruleNameHighRiskActivity
# 		Then assert ruleResults[0].result == RuleResult.Rejected



