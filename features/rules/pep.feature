# @parallel=false
# Feature: Pep Rule

# 	Background:
# 		* def createPartner = read('../_data/testPartner.js')
# 		* def ruleNamePep = "PEP"
# 		* def catalogID = 'a41b149c-949d-5370-b9d0-fbdb40c88f8b'
# 		* def createProfileIndividual = read('../_data/profileIndividual.js')
# 		* def createPEP = read('../_data/createPepCoaf.js')

# 		* def partner = call createPartner { id: "cd7a5cdc-5a8e-42ad-91c5-450558521522", name: "PepRuleOffer", document_number: "12345678910", segregation_type: "BY_PARTNER", use_callback_v2: true }

# 		Given url registrationUrlInt
# 		And path '/partners'
# 		And header Content-Type = 'application/json'
# 		And request partner
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 		* def PepRulePartners = response.partner_id
# 		* def offer = { offer_type : 'PepRuleOffer', product: 'maquininha'}

# 		Given url registrationUrlInt
# 		And path '/offers'
# 		And header Content-Type = 'application/json'
# 		And request offer
# 		When method POST
# 		Then assert responseStatus == 201 || responseStatus == 409

# 		* def PepRuleOffer = response.offer_type

# 		Given url complianceUrlInt
# 		And path '/catalogs/' + catalogID
# 		And header Content-Type = 'application/json'
# 		And def func = read('../_data/singleLevelCatalogForConfig.js')
# 		And def catalogCompany = call func { offer_type: '#(PepRuleOffer)', role_type: 'CUSTOMER', profile_type: 'INDIVIDUAL', account_flag: false, rulesConfig: { pep_params: {}, watch_list_params: {  want_pep_tag: true, wanted_sources: ["OFAC_CAPTA","OFAC"] }} }
# 		And request catalogCompany
# 		When method PUT
# 		Then assert responseStatus == 200

# Scenario: Should Profile found in Watchlist pep list

# 		* def documentNumber =  CPFGenerator()
# 		* def WatchlistBody = { document_number: "#(documentNumber)", title:"SomeToken", name: "Someone", link: "/link", watch: "", other: "", entries: ["someEntry"], sources: ["PEP"]}
# 		* def profile = call createProfileIndividual {  partner_id: '#(PepRulePartners)', document_number: '#(documentNumber)', offer_type: '#(PepRuleOffer)', role_type: 'CUSTOMER' }

# 		Given url temis_mock
# 		And path '/compliance/watchlist'
# 		And request WatchlistBody
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def validationBody = { title:"SomeToken", name: "Someone", link: "/link", watch: "", other: "", entries: ["someEntry"], sources: ["PEP"]}

# 		Given url temis_mock
# 		And path '/compliance/watchlist/' + documentNumber
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains validationBody

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		* def expectedResponse =
# 			"""
# 			{

#     entity_id: "#(profileID)",
#     engine_name: "PROFILE",
#     result: "#(RuleResult.Analysing)",
#     rule_set_result: [
#         {
#             step_number: 0,
#             set: "WATCHLIST",
#             name: "WATCHLIST",
#             result: "#(RuleResult.Approved)",
#             pending: false,
#         	metadata: [
#                 {
#                     link: "/link",
#                     name: "Someone",
#                     other: "",
#                     title: "SomeToken",
#                     watch: "",
#                     entries: [
#                         "someEntry"
#                     ],
#                     sources: [
#                         "PEP"
#                     ]
#                 }
#             ],
#             tags: [
#                 "PEP"
#             ]
#         },
#         {
#             step_number: 0,
#             set: "PEP",
#             name: "PEP",
#             result: "#(RuleResult.Analysing)",
#             pending: true,
#             metadata: {
#                 pep_sources: [
#                     "WATCHLIST"
#                 ]
#             }
#         }
#     ]
# 	}
# 			"""

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Analysing)' }
# 		And match response contains expectedResponse


# 		Given url complianceUrlInt
# 		And path '/profile/' + profileID
# 		When method GET
# 		Then assert responseStatus == 200
# 		Then assert response.person.document_number == documentNumber
# 		And match response.person.watchlist contains { sources: ["PEP"]}


# Scenario: Should Profile declared himself as pep

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(PepRulePartners)', document_number: '#(documentNumber)', offer_type: '#(PepRuleOffer)', role_type: 'CUSTOMER' }
# 		* profile.individual.pep = true

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		* def expectedResponse =
# 			"""
# 			{

#     entity_id: "#(profileID)",
#     engine_name: "PROFILE",
#     result: "#(RuleResult.Analysing)",
#     rule_set_result: [
#         {
#             step_number: 0,
#             set: "PEP",
#             name: "PEP",
#             result: "#(RuleResult.Analysing)",
#             pending: true,
#             metadata: {
#                 pep_sources: [
#                     "SELF_DECLARED"
#                 ]
#             }
#         }
#     ]
# 	}
# 			"""

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Analysing)' }
# 		And match response contains deep expectedResponse

# Scenario: Should Profile found in PEP COAF

# 		* def documentNumber =  CPFGenerator()
# 		* def profile = call createProfileIndividual {  partner_id: '#(PepRulePartners)', document_number: '#(documentNumber)', offer_type: '#(PepRuleOffer)', role_type: 'CUSTOMER' }
# 		* def pep = call createPEP {document_number: '#(documentNumber)'}

#         Given url temis_restrictive_list
#         And path '/pep/upload'
#         And param author = "Teste CSV 2"
#         And header Content-Type = 'text/csv'
#         And request pep
#         When method POST
#         Then assert responseStatus == 200
#         And  assert response.number_of_uploaded_records == 1

# 		Given url temis_restrictive_list
#         And path '/pep/' + documentNumber
# 		And retry until karate.get ('response.document_number') == documentNumber
#         When method GET
#         Then assert responseStatus == 200
#         And  assert response.document_number == documentNumber

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		* def expectedResponse =
# 			"""
# 			{

#     entity_id: "#(profileID)",
#     engine_name: "PROFILE",
#     result: "#(RuleResult.Analysing)",
#     rule_set_result: [
#         {
#             step_number: 0,
#             set: "PEP",
#             name: "PEP",
#             result: "#(RuleResult.Analysing)",
#             pending: true,
#             metadata: {
#                 pep_sources: [
#                     "COAF"
#                 ],
# 				pep_information: {
#                     name: "TESTE FULANO PEP CSV",
#                     role: "ADJUNTO DO ADVOGADO GERAL",
#                     source: "COAF",
#                     end_date: "2022-04-04T00:00:00Z",
#                     created_at: "##notnull",
#                     start_date: "2021-08-28T00:00:00Z",
#                     institution: "ADVOCACIA GERAL DA UNIAO",
#                     document_number: "#(documentNumber)"
#                 }
#             }
#         }
#     ]
# 	}
# 			"""

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Analysing
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Analysing)' }
# 		And match response contains deep expectedResponse


# Scenario: Should be approved by pep rule

# 		* def documentNumber =  CPFGenerator()
# 		* def WatchlistBody = { document_number: "#(documentNumber)", title:"SomeToken", name: "Someone", link: "/link", watch: "", other: "", entries: ["someEntry"], sources: []}
# 		* def profile = call createProfileIndividual {  partner_id: '#(PepRulePartners)', document_number: '#(documentNumber)', offer_type: '#(PepRuleOffer)', role_type: 'CUSTOMER' }

# 		Given url temis_mock
# 		And path '/compliance/watchlist'
# 		And request WatchlistBody
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def validationBody = { title:"SomeToken", name: "Someone", link: "/link", watch: "", other: "", entries: ["someEntry"], sources: []}

# 		Given url temis_mock
# 		And path '/compliance/watchlist/' + documentNumber
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains validationBody

# 		Given url registrationUrlInt
# 		And path '/profile'
# 		And header Content-Type = 'application/json'
# 		And request profile
# 		When method POST
# 		Then assert responseStatus == 201

# 		* def profileID = response.profile_id

# 		* def expectedResponse =
# 			"""
# 			{

#     entity_id: "#(profileID)",
#     engine_name: "PROFILE",
#     result: "#(RuleResult.Approved)",
#     rule_set_result: [
#         {
#             step_number: 0,
#             set: "PEP",
#             name: "PEP",
#             result: "#(RuleResult.Approved)",
#             pending: false,
#             metadata: null
#         }
#     ]
# 	}
# 			"""

# 		Given url complianceUrlInt
# 		And retry until karate.get ('response.result') == RuleResult.Approved
# 		And path '/state/' + profileID
# 		And header Content-Type = 'application/json'
# 		When method GET
# 		Then assert responseStatus == 200
# 		And match response contains { entity_id: '#(profileID)', result: '#(RuleResult.Approved)' }
# 		And match response contains deep expectedResponse
