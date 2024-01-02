# @parallel=false
# Feature: Blacklist Rule

# 	  Background:
#     * url registrationUrlInt
#     * def limit = read('classpath:_data/limit.js')
#     * def createProfileCustomerIndividual = read('classpath:_data/profileIndividual.js')
#     * def createDocument = read('classpath:_data/documentByType.js')

# 	Scenario: Should profile gets a manual block after automatic approval

# 		* def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
# 		* def profile = call createProfileCustomerIndividual {  partner_id: '#(PartnerID.Revolut)', callback_url: '#(callbackURL)', document_number: '#(documentNumberIndividual)', offer_type: '#(OfferType.DigitalTransfInvest)', role_type: 'CUSTOMER' }

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
# 			zip_code: "14222-888",
# 			street: "Rua Maria Eugênia",
# 			number: "456",
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

# 		* def document = call createDocument { type: 'IDENTIFICATION'}

# 		Given url registrationUrlInt
# 		And path '/profile/'+profileID+'/document'
# 		And request document
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def documentID = response.document_id
# 		* def file = read('classpath:_data/document_sample.jpg')

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
# 		And  assert response.result == RuleResult.Approved

# 		Given url complianceUrlInt
# 		And path '/override'
# 		And header Content-Type = 'application/json'
# 		And def func = read('classpath:_data/override.js')
# 		And def override = call func { entityID : '#(profileID)' , ruleSet: "MANUAL_BLOCK" , ruleName: "MANUAL_BLOCK" , result : "BLOCKED" }
# 		And request override
# 		When method POST
# 		Then assert responseStatus == 200

# 		Given url complianceUrlInt
# 		And path '/check/' + profileID
# 		And request {entity_type: "PROFILE"}
# 		When method POST
# 		Then assert responseStatus == 200
# 		And  assert response.result == "BLOCKED"

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == 'BLOCKED'
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: 'BLOCKED' }
# 		And match response contains deep { rule_set_result: [{name: "MANUAL_BLOCK", result: "BLOCKED"}] }

# 		Given url temis_query
# 		And path '/profile/' + profileID
# 		And retry until karate.get('response.onboarding_status.status') == "BLOCKED"
# 		When method GET
# 		Then assert responseStatus == 200

# 		Given url callbackURL
# 		And path '/' + profileID
# 		And retry until karate.match("response contains deep { onboarding_status: {status: 'BLOCKED'}}").pass
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains deep { entity_id : "#(profileID)", onboarding_status : { status: "#(RuleResult.Blocked)" }}