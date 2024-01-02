# @parallel=false
# Feature: Rules Caf

#   Background:
#     * url registrationUrlInt
#     * def createProfileIndividual = read('../_data/profileIndividual.js')
#     * def offerCAF = "CAF_RULE_OFFER"
#     * def offerBureau = "BUREAU"
#     * def offerBureauAndCaf = "BUREAU_AND_CAF_RULE_OFFER"
#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def templateID = "SomeTempĺateID"

#     * def CafResultApproved = "APPROVED"
#     * def CafResultReproved = "REPROVED"
#     * def CafResultAnalysing = "ANALYSING"
#     * def CafResultPending = "PENDING"
#     * def CafResultPendingOcr = "PENDING_OCR"
#     * def CafResultProcessing = "PROCESSING"
#     * def CafResultRejected = "REJECTED"

#   Scenario: Should Profile is not created in compliance because it did not go through the onboarding process

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id

#     Given url complianceUrlInt
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : null}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Analysing
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains { entity_id: '#(profileID)', result: '#(CafResultAnalysing)' }
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultAnalysing)', pending: true, metadata: null, problems:[{code: 'NOT_FOUND_CAF_ANALYSIS', detail: ''}]}


#   Scenario: Given a profile was Approved by CAF, should enrich profile using CAF as a Provider and get Appoved Status

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultApproved)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultApproved)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultApproved
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultApproved)"}]}

#     Given url registrationUrlInt
#     And path "/documents"
#     And param entity_id = profileID
#     And retry until karate.get ('response.length') == 2
#     And retry until response.length == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"type": "PROOF_OF_LIFE"}
#     And match response contains deep {"type": "IDENTIFICATION"}

#     * def selfieID = response[0].document_id
#     * def cnhID = response[1].document_id
#     * if (response[0].type == "IDENTIFICATION") selfieID = response[1].document_id
#     * if (response[1].type == "PROOF_OF_LIFE") cnhID = response[0].document_id

#     Given url registrationUrlInt
#     And path "/document/" + selfieID + "/files"
#     And retry until karate.get ('response.length') == 1
#     When method GET
#     Then assert responseStatus == 200
#     And assert response.length == 1
#     And match response contains deep {"file_side": "ALL"}

#     Given url registrationUrlInt
#     And path "/document/" + cnhID + "/files"
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"file_side": "BACK"}
#     And match response contains deep {"file_side": "FRONT"}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultApproved
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultApproved)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Approved
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains { entity_id: '#(profileID)', result: '#(CafResultApproved)' }
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultApproved)', pending: false, metadata: null}

#   Scenario: Given a profile was Process by CAF, should enrich profile using CAF as a Provider and get Analysing Status

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultProcessing)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultProcessing)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultAnalysing
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultAnalysing)"}]}

#     Given url registrationUrlInt
#     And path "/documents"
#     And param entity_id = profileID
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"type": "PROOF_OF_LIFE"}
#     And match response contains deep {"type": "IDENTIFICATION"}

#     * def selfieID = response[0].document_id
#     * def cnhID = response[1].document_id
#     * if (response[0].type == "IDENTIFICATION") selfieID = response[1].document_id
#     * if (response[1].type == "PROOF_OF_LIFE") cnhID = response[0].document_id

#     Given url registrationUrlInt
#     And path "/document/" + selfieID + "/files"
#     And retry until karate.get ('response.length') == 1
#     When method GET
#     Then assert responseStatus == 200
#     And assert response.length == 1
#     And match response contains deep {"file_side": "ALL"}

#     Given url registrationUrlInt
#     And path "/document/" + cnhID + "/files"
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"file_side": "BACK"}
#     And match response contains deep {"file_side": "FRONT"}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultAnalysing
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultAnalysing)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Analysing
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains { entity_id: '#(profileID)', result: '#(CafResultAnalysing)' }
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultAnalysing)', pending: true, metadata: null, problems: [{code: 'CAF_ANALYSIS_PENDING', detail:['#(executionID)']}]}

#   Scenario: Given a profile was Rejected by CAF, should enriche profile using CAF as a Provider and get Rejected Status

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultReproved)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultReproved)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultRejected
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     And retry until responseStatus == 200
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultRejected)"}]}

#     Given url registrationUrlInt
#     And path "/documents"
#     And param entity_id = profileID
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"type": "PROOF_OF_LIFE"}
#     And match response contains deep {"type": "IDENTIFICATION"}

#     * def selfieID = response[0].document_id
#     * def cnhID = response[1].document_id
#     * if (response[0].type == "IDENTIFICATION") selfieID = response[1].document_id
#     * if (response[1].type == "PROOF_OF_LIFE") cnhID = response[0].document_id

#     Given url registrationUrlInt
#     And path "/document/" + selfieID + "/files"
#     And retry until karate.get ('response.length') == 1
#     When method GET
#     Then assert responseStatus == 200
#     And assert response.length == 1
#     And match response contains deep {"file_side": "ALL"}

#     Given url registrationUrlInt
#     And path "/document/" + cnhID + "/files"
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"file_side": "BACK"}
#     And match response contains deep {"file_side": "FRONT"}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultRejected
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultRejected)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Rejected
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains { entity_id: '#(profileID)', result: '#(CafResultRejected)' }
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultRejected)', pending: false, metadata: null}

#   Scenario: Given a profile was Rejected by CAF and then approved, should enrich profile using CAF as a Provider and get the last valid status (Approved)

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultReproved)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultReproved)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until response.providers[0].status == CafResultRejected
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     And retry until karate.get ('responseStatus') == 200
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultRejected)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultRejected
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultRejected)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Rejected
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultRejected)', pending: false, metadata: null}


#     * def bodyTransaction = { status: "#(CafResultApproved)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultApproved)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultApproved
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultApproved)"}]}

#     Given url registrationUrlInt
#     And path "/documents"
#     And param entity_id = profileID
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"type": "PROOF_OF_LIFE"}
#     And match response contains deep {"type": "IDENTIFICATION"}

#     * def selfieID = response[0].document_id
#     * def cnhID = response[1].document_id
#     * if (response[0].type == "IDENTIFICATION") selfieID = response[1].document_id
#     * if (response[1].type == "PROOF_OF_LIFE") cnhID = response[0].document_id

#     Given url registrationUrlInt
#     And path "/document/" + selfieID + "/files"
#     And retry until karate.get ('response.length') == 1
#     When method GET
#     Then assert responseStatus == 200
#     And assert response.length == 1
#     And match response contains deep {"file_side": "ALL"}

#     Given url registrationUrlInt
#     And path "/document/" + cnhID + "/files"
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"file_side": "BACK"}
#     And match response contains deep {"file_side": "FRONT"}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultApproved
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultApproved)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Approved
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultApproved)', pending: false, metadata: null}

#   Scenario: Given a profile was Pending by CAF, should enrich profile using CAF as a Provider and get Pending Status

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultPending)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultPending)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until response.providers[0].status == CafResultAnalysing
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     And retry until karate.get ('responseStatus') == 200
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultAnalysing)"}]}


#     * def bodyTransaction = { status: "#(CafResultApproved)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultApproved)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultApproved
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultApproved)"}]}

#     Given url registrationUrlInt
#     And path "/documents"
#     And param entity_id = profileID
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"type": "PROOF_OF_LIFE"}
#     And match response contains deep {"type": "IDENTIFICATION"}

#     * def selfieID = response[0].document_id
#     * def cnhID = response[1].document_id
#     * if (response[0].type == "IDENTIFICATION") selfieID = response[1].document_id
#     * if (response[1].type == "PROOF_OF_LIFE") cnhID = response[0].document_id

#     Given url registrationUrlInt
#     And path "/document/" + selfieID + "/files"
#     And retry until karate.get ('response.length') == 1
#     When method GET
#     Then assert responseStatus == 200
#     And assert response.length == 1
#     And match response contains deep {"file_side": "ALL"}

#     Given url registrationUrlInt
#     And path "/document/" + cnhID + "/files"
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"file_side": "BACK"}
#     And match response contains deep {"file_side": "FRONT"}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultApproved
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultApproved)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Approved
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultApproved)', pending: false, metadata: null}

#   Scenario: Given a profile was Pending_OCR by CAF, should enrich profile using CAF as a Provider and get Pending Status

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultPendingOcr)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultPendingOcr)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultAnalysing
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     And retry until responseStatus == 200
#     When method GET
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultAnalysing)"}]}

#     Given url registrationUrlInt
#     And path "/documents"
#     And param entity_id = profileID
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"type": "PROOF_OF_LIFE"}
#     And match response contains deep {"type": "IDENTIFICATION"}

#     * def selfieID = response[0].document_id
#     * def cnhID = response[1].document_id
#     * if (response[0].type == "IDENTIFICATION") selfieID = response[1].document_id
#     * if (response[1].type == "PROOF_OF_LIFE") cnhID = response[0].document_id

#     Given url registrationUrlInt
#     And path "/document/" + selfieID + "/files"
#     And retry until karate.get ('response.length') == 1
#     When method GET
#     Then assert responseStatus == 200
#     And assert response.length == 1
#     And match response contains deep {"file_side": "ALL"}

#     Given url registrationUrlInt
#     And path "/document/" + cnhID + "/files"
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"file_side": "BACK"}
#     And match response contains deep {"file_side": "FRONT"}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultAnalysing
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultAnalysing)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Analysing
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultAnalysing)', pending: true, metadata: null, problems: [{code: 'CAF_ANALYSIS_PENDING', detail:['#(executionID)']}]}


#   Scenario: Given a profile was Approved by CAF, should enrich profile using CAF as a Provider and get reproved Status

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())
#     * def profile = call createProfileIndividual { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerCAF)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultApproved)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultApproved)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultApproved
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     And retry until karate.get ('responseStatus') == 200
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultApproved)"}]}


#     * def bodyTransaction = { status: "#(CafResultReproved)", onboarding_id: "#(onboardingID)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultReproved)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultRejected
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerCAF
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {providers:[{provider_name:"CAF_ENRICHER",request_id:"#(executionID)",status:"#(CafResultRejected)"}]}

#     Given url registrationUrlInt
#     And path "/documents"
#     And param entity_id = profileID
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"type": "PROOF_OF_LIFE"}
#     And match response contains deep {"type": "IDENTIFICATION"}

#     * def selfieID = response[0].document_id
#     * def cnhID = response[1].document_id
#     * if (response[0].type == "IDENTIFICATION") selfieID = response[1].document_id
#     * if (response[1].type == "PROOF_OF_LIFE") cnhID = response[0].document_id

#     Given url registrationUrlInt
#     And path "/document/" + selfieID + "/files"
#     And retry until karate.get ('response.length') == 1
#     When method GET
#     Then assert responseStatus == 200
#     And assert response.length == 1
#     And match response contains deep {"file_side": "ALL"}

#     Given url registrationUrlInt
#     And path "/document/" + cnhID + "/files"
#     And retry until karate.get ('response.length') == 2
#     When method GET
#     Then assert responseStatus == 200
#     And match response contains deep {"file_side": "BACK"}
#     And match response contains deep {"file_side": "FRONT"}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.person.enriched_information.providers[0].status') == CafResultRejected
#     And path '/profile/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And  match response.person.enriched_information contains deep { providers : [ {provider_name : "CAF_ENRICHER", request_id: '#(executionID)', status: "#(CafResultRejected)"}]}

#     Given url complianceUrlInt
#     And retry until karate.get ('response.result') == RuleResult.Rejected
#     And path '/state/' + profileID
#     And header Content-Type = 'application/json'
#     When method GET
#     Then assert responseStatus == 200
#     And match response.rule_set_result contains { step_number: 0, set: 'CAF_ANALYSIS', name: 'CAF_ANALYSIS_RESULT', result: '#(CafResultRejected)', pending: false, metadata: null}


#   Scenario: Person is only enriched with Bureau, use this info as valid

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())

#     Given url bureauMockUrl
#     And path '/mock/' + documentNumberIndividual
#     And header Content-Type = 'application/json'
#     And request {"mock_name": "cpf-pending"}
#     When method POST
#     Then assert responseStatus == 200

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And def func = read('../_data/profileIndividual.js')
#     And def profile = call func { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerBureau)', role_type: 'CUSTOMER'}
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].provider_name') == "INDIVIDUAL_BUREAU_ENRICHER"
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerBureau
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {name:"FULANO DOS MOCKS", "individual":{birth_date: "23/11/1992", situation: 2}, providers:[{provider_name: "INDIVIDUAL_BUREAU_ENRICHER"}]}

#   Scenario: Person is enriched in both sources, but does not have the same data filled in, all data from both sources has to be in the output

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())

#     Given url bureauMockUrl
#     And path '/mock/' + documentNumberIndividual
#     And header Content-Type = 'application/json'
#     And request {"mock_name": "cpf-pending"}
#     When method POST
#     Then assert responseStatus == 200

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And def func = read('../_data/profileIndividual.js')
#     And def profile = call func { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerBureauAndCaf)', role_type: 'CUSTOMER'}
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerBureauAndCaf)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultPending)", onboarding_id: "#(onboardingID)", cpf: "#(documentNumberIndividual)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultPending)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultAnalysing
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerBureauAndCaf
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {individual : { birth_date: "25/12/1980", situation: 2 }, providers : [{ provider_name: "CAF_ENRICHER", request_id: "#(executionID)", status: "#(CafResultAnalysing)" },{provider_name : "INDIVIDUAL_BUREAU_ENRICHER"}]}

#   Scenario: person is enriched in both sources, and has the same data filled in, should prioritize those from CAF

#     * def documentNumberIndividual = DocumentNormalizer(CPFGenerator())

#     Given url bureauMockUrl
#     And path '/mock/' + documentNumberIndividual
#     And header Content-Type = 'application/json'
#     And request {"mock_name": "cpf-not-found"}
#     When method POST
#     Then assert responseStatus == 200

#     Given url registrationUrlInt
#     And path '/profile'
#     And header Content-Type = 'application/json'
#     And def func = read('../_data/profileIndividual.js')
#     And def profile = call func { partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerBureauAndCaf)', role_type: 'CUSTOMER'}
#     And request profile
#     When method POST
#     Then assert responseStatus == 201

#     * def profileID = response.profile_id
#     * def createOnboarding =  { profile_id: "#(profileID)", person_type: "INDIVIDUAL", partner_id: '#(PartnerID.OpenSolo)', document_number: '#(documentNumberIndividual)', offer_type: '#(offerBureauAndCaf)', role_type: 'CUSTOMER'}

#     Given url temis_enrichment
#     And path '/onboarding'
#     And header Content-Type = 'application/json'
#     And request createOnboarding
#     When method POST
#     Then assert responseStatus == 201

#     * def onboardingID = response.onboarding_id
#     * def bodyTransaction = { status: "#(CafResultPending)", onboarding_id: "#(onboardingID)", cpf: "#(documentNumberIndividual)"}
#     * def executionID = uuid()

#     Given url temis_mock
#     And path '/v1/transactions/' + executionID
#     And header Content-Type = 'application/json'
#     And request bodyTransaction
#     When method POST
#     Then assert responseStatus == 201

#     * def executionID = response.execution_id
#     * def bodyCallbackCaf = { type: "status_updated", report: "report", templateId: "628fdaea1264c40009ae7f72", uuid : "#(executionID)", status: "#(CafResultPending)", date: "2021-09-15T20:40:31.253511Z" }

#     Given url temis_enrichment
#     And path '/callback/caf'
#     And header Content-Type = 'application/json'
#     And request bodyCallbackCaf
#     When method POST
#     Then assert responseStatus == 200

#     Given url temis_enrichment
#     And retry until karate.get ('response.providers[0].status') == CafResultAnalysing
#     And path "/enrich/" + documentNumberIndividual
#     And param person_type = "INDIVIDUAL"
#     And param offer_type = offerBureauAndCaf
#     And param partner_id = PartnerID.OpenSolo
#     And param profile_id = profileID
#     When method GET
#     Then assert responseStatus == 200
#     And  match response contains deep {individual : { birth_date: "25/12/1980", situation: 0 }, providers : [{ provider_name: "CAF_ENRICHER", request_id: "#(executionID)", status: "#(CafResultAnalysing)" },{provider_name : "INDIVIDUAL_BUREAU_ENRICHER"}]}
