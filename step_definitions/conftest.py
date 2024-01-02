import random
import time
import requests
import json
from functools import partial
from pytest_bdd import given, then, when, parsers
from support import utils
from support import config
from support.classes.individual import Individual
from support.config import Config
from support.rest_service import RestService


EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)


def pytest_bdd_step_error(
    request, feature, scenario, step, step_func, step_func_args, exception
):
    print(f"Scenario failed: {scenario.name}")


@given(
    parse_num(
        'an individual customer PF with partner "{partnerID}", offer "{offerType}", income {income:d}'
    ),
    target_fixture="response",
)
def post_individual_customer(partnerID, offerType, income):
    idPartner = None
    idOffer = None

    if partnerID == "Revolut":
        idPartner = Config.Revolut
    if partnerID == "NUBANK":
        idPartner = Config.Nubank
    if partnerID == "NUBANK2":
        idPartner = Config.Nubank2
    if partnerID == "Susnstate":
        idPartner = Config.Susnstate
    if partnerID == "OpenSolo":
        idPartner = Config.OpenSolo
    if partnerID == "BexsBanco":
        idPartner = Config.BexsBanco
    if partnerID == "Pay":
        idPartner = Config.Pay
    if partnerID == "BoaCompra":
        idPartner = Config.BoaCompra
    if partnerID == "Dlocal":
        idPartner = Config.Dlocal
    if partnerID == "BlacklistPartner":
        idPartner = Config.BlacklistPartner
    if partnerID == "Keeta":
        idPartner = Config.Keeta

    if offerType == "DigitalTransfInvest":
        idOffer = Config.DigitalTransfInvest
    if offerType == "MaquininhaAPI":
        idOffer = Config.MaquininhaAPI
    if offerType == "MaquininhaCripto":
        idOffer = Config.MaquininhaCripto
    if offerType == "MaquininhaPortal":
        idOffer = Config.MaquininhaPortal
    if offerType == "WebpaymentMarketplace":
        idOffer = Config.WebpaymentMarketplace
    if offerType == "PayMyTuition":
        idOffer = Config.PayMyTuition
    if offerType == "Blacklist":
        idOffer = Config.Blacklist

    payload = {
        "partner_id": idPartner,
        "offer_type": idOffer,
        "role_type": "CUSTOMER",
        "profile_type": "INDIVIDUAL",
        "document_number": utils.generate_cpf(),
        "callback_url": config.Config.callbackURL,
        "email": "teste@teste.com",
        "individual": {
            "first_name": "Test",
            "last_name": "Digital",
            "date_of_birth": "1991-07-30T00:00:00Z",
            "income": income,
            "phones": [
                {
                    "type": "BUSINESS",
                    "number": "123",
                    "country_code": "55",
                    "area_code": "11",
                }
            ],
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    print(responsjson)
    assert response.status_code == 201

    return response


@given(
    parse_num(
        'an individual customer PF with partner "{partnerID}", offer "{offerType}", income {income:d}, parent_id and without name and email'
    ),
    target_fixture="response",
)
def post_individual_customer(response, partnerID, offerType, income):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    idPartner = None
    idOffer = None

    if partnerID == "Revolut":
        idPartner = Config.Revolut
    if partnerID == "NUBANK":
        idPartner = Config.Nubank
    if partnerID == "NUBANK2":
        idPartner = Config.Nubank2
    if partnerID == "Susnstate":
        idPartner = Config.Susnstate
    if partnerID == "OpenSolo":
        idPartner = Config.OpenSolo
    if partnerID == "BexsBanco":
        idPartner = Config.BexsBanco
    if partnerID == "Pay":
        idPartner = Config.Pay
    if partnerID == "Keeta":
        idPartner = Config.Keeta

    if offerType == "DigitalTransfInvest":
        idOffer = Config.DigitalTransfInvest
    if offerType == "MaquininhaAPI":
        idOffer = Config.MaquininhaAPI
    if offerType == "MaquininhaCripto":
        idOffer = Config.MaquininhaCripto
    if offerType == "MaquininhaPortal":
        idOffer = Config.MaquininhaPortal
    if offerType == "WebpaymentMarketplace":
        idOffer = Config.WebpaymentMarketplace
    if offerType == "PayMyTuition":
        idOffer = Config.PayMyTuition

    payload = {
        "partner_id": idPartner,
        "offer_type": idOffer,
        "parent_id": profileID,
        "role_type": "CUSTOMER",
        "profile_type": "INDIVIDUAL",
        "document_number": utils.generate_cpf(),
        "callback_url": config.Config.callbackURL,
        "individual": {
            "first_name": "Test",
            "date_of_birth": "1991-07-30T00:00:00Z",
            "income": income,
            "phones": [
                {
                    "type": "BUSINESS",
                    "number": "123",
                    "country_code": "55",
                    "area_code": "11",
                }
            ],
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    print(responsjson)
    assert response.status_code == 201

    return response


@given(
    parse_num('create customer PJ with partner "{partnerID}", offer "{offerType}"'),
    target_fixture="response",
)
def post_company_customer(documentNumber, partnerID, offerType):
    idPartner = None
    idOffer = None

    if partnerID == "Revolut":
        idPartner = Config.Revolut
    if partnerID == "NUBANK":
        idPartner = Config.Nubank
    if partnerID == "NUBANK2":
        idPartner = Config.Nubank2
    if partnerID == "Susnstate":
        idPartner = Config.Susnstate
    if partnerID == "OpenSolo":
        idPartner = Config.OpenSolo
    if partnerID == "BexsBanco":
        idPartner = Config.BexsBanco
    if partnerID == "B2W":
        idPartner = Config.B2W
    if partnerID == "Dlocal":
        idPartner = Config.Dlocal
    if partnerID == "BlacklistPartner":
        idPartner = Config.BlacklistPartner
    if partnerID == "Keeta":
        idPartner = Config.Keeta

    if offerType == "DigitalTransfInvest":
        idOffer = Config.DigitalTransfInvest
    if offerType == "MaquininhaAPI":
        idOffer = Config.MaquininhaAPI
    if offerType == "MaquininhaCripto":
        idOffer = Config.MaquininhaCripto
    if offerType == "MaquininhaPortal":
        idOffer = Config.MaquininhaPortal
    if offerType == "WebpaymentMarketplace":
        idOffer = Config.WebpaymentMarketplace
    if offerType == "PayMyTuition":
        idOffer = Config.PayMyTuition
    if offerType == "Blacklist":
        idOffer = Config.Blacklist

    payload = {
        "partner_id": idPartner,
        "offer_type": idOffer,
        "role_type": "CUSTOMER",
        "profile_type": "COMPANY",
        "document_number": documentNumber,
        "callback_url": config.Config.callbackURL,
        "company": {
            "legal_name": "Empresa Legal",
            "business_name": "Empresa Legal S.A.",
            "tax_payer_identification": "1234",
            "company_registration_number": "56789",
            "date_of_incorporation": "1989-02-13",
            "place_of_incorporation": "BR",
            "annual_income": 1000,
            "share_capital": {"amount": 10009, "currency": "USD"},
            "license": "Open Source",
            "website": "www.bexs.com",
            "goods_delivery": {
                "average_delivery_days": 5,
                "shipping_methods": "BOAT",
                "tracking_code_available": True,
            },
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    print(responsjson)
    assert response.status_code == 201

    return response


@when(
    parse_num('create supplier PJ with partner "{partnerID}", offer "{offerType}"'),
    target_fixture="response",
)
def post_company_customer(documentNumber, partnerID, offerType):
    idPartner = None
    idOffer = None

    if partnerID == "B2W":
        idPartner = Config.Revolut

    if offerType == "WebpaymentMarketplace":
        idOffer = Config.WebpaymentMarketplace

    payload = {
        "partner_id": idPartner,
        "offer_type": idOffer,
        "role_type": "SUPPLIER",
        "profile_type": "COMPANY",
        "document_number": documentNumber,
        "callback_url": config.Config.callbackURL,
        "company": {
            "legal_name": "Empresa Legal",
            "business_name": "Empresa Legal S.A.",
            "tax_payer_identification": "1234",
            "company_registration_number": "56789",
            "date_of_incorporation": "1989-02-13",
            "place_of_incorporation": "BR",
            "annual_income": 1000,
            "share_capital": {"amount": 10009, "currency": "USD"},
            "license": "Open Source",
            "website": "www.bexs.com",
            "goods_delivery": {
                "average_delivery_days": 5,
                "shipping_methods": "BOAT",
                "tracking_code_available": True,
            },
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    print(responsjson)
    assert response.status_code == 201

    return response


@given(
    parse_num('create Merchant PJ with partner "{partnerID}", offer "{offerType}"'),
    target_fixture="response",
)
def post_company_customer(partnerID, offerType):
    documentNumber = utils.generate_cnpj
    idPartner = None
    idOffer = None

    if partnerID == "Revolut":
        idPartner = Config.Revolut
    if partnerID == "NUBANK":
        idPartner = Config.Nubank
    if partnerID == "NUBANK2":
        idPartner = Config.Nubank2
    if partnerID == "Susnstate":
        idPartner = Config.Susnstate
    if partnerID == "OpenSolo":
        idPartner = Config.OpenSolo
    if partnerID == "BexsBanco":
        idPartner = Config.BexsBanco
    if partnerID == "Pay":
        idPartner = Config.Pay
    if partnerID == "Keeta":
        idPartner = Config.Keeta

    if offerType == "DigitalTransfInvest":
        idOffer = Config.DigitalTransfInvest
    if offerType == "MaquininhaAPI":
        idOffer = Config.MaquininhaAPI
    if offerType == "MaquininhaCripto":
        idOffer = Config.MaquininhaCripto
    if offerType == "MaquininhaPortal":
        idOffer = Config.MaquininhaPortal
    if offerType == "WebpaymentMarketplace":
        idOffer = Config.WebpaymentMarketplace
    if offerType == "PayMyTuition":
        idOffer = Config.PayMyTuition

    payload = {
        "partner_id": idPartner,
        "offer_type": idOffer,
        "role_type": "MERCHANT",
        "profile_type": "COMPANY",
        "document_number": "xxx",
        "callback_url": config.Config.callbackURL,
        "company": {
            "legal_name": "Empresa Legal",
            "business_name": "Empresa Legal S.A.",
            "tax_payer_identification": "1234",
            "company_registration_number": "56789",
            "date_of_incorporation": "1989-02-13",
            "place_of_incorporation": "BR",
            "annual_income": 1000,
            "share_capital": {"amount": 10009, "currency": "USD"},
            "license": "Open Source",
            "website": "www.bexs.com",
            "goods_delivery": {
                "average_delivery_days": 5,
                "shipping_methods": "BOAT",
                "tracking_code_available": True,
            },
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    assert response.status_code == 409

    return response


@given(
    "create counterparty PF",
    target_fixture="response",
)
def post_individual_customer():
    payload = {
        "partner_id": "67ca469e-143f-4867-b182-4ac9bdc4f111",
        "offer_type": "MAQUININHA_API_01",
        "role_type": "COUNTERPARTY",
        "profile_type": "INDIVIDUAL",
        "document_number": utils.generate_cpf(),
        "email": "teste@teste.com",
        "individual": {
            "first_name": "Test",
            "last_name": "Digital",
            "date_of_birth": "1991-07-30T00:00:00Z",
            "phones": [
                {
                    "type": "BUSINESS",
                    "number": "123",
                    "country_code": "55",
                    "area_code": "11",
                }
            ],
        },
    }

    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    assert response.status_code == 201

    return response


@given(
    "create counterparty PJ",
    target_fixture="response",
)
def counterparty_pj_customer():
    payload = {
        "partner_id": "67ca469e-143f-4867-b182-4ac9bdc4f111",
        "offer_type": "MAQUININHA_API_01",
        "role_type": "COUNTERPARTY",
        "profile_type": "COMPANY",
        "document_number": utils.generate_cnpj(),
        "company": {
            "legal_name": "Empresa Legal",
            "business_name": "Empresa Legal S.A.",
            "tax_payer_identification": "1234",
            "company_registration_number": "56789",
            "date_of_incorporation": "1989-02-13",
            "place_of_incorporation": "BR",
            "annual_income": 1000,
            "share_capital": {"amount": 10009, "currency": "USD"},
            "license": "Open Source",
            "website": "www.bexs.com",
            "goods_delivery": {
                "average_delivery_days": 5,
                "shipping_methods": "BOAT",
                "tracking_code_available": True,
            },
        },
    }

    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    assert response.status_code == 201

    return response


@when(
    parse_num('add the document "{document}", number "{number}" and name "{name}"'),
    target_fixture="responseDocument",
)
def post_document(response, document, number, name):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "type": document,
        "expiration_date": "2025-12-30",
        "emission_date": "2022-12-30T00:00:00Z",
        "document_fields": {"number": number, "name": name},
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/document".format(profileID)

    responseDocument = requests.post(url=url, headers=header, data=payload)
    assert responseDocument.status_code == 201

    return responseDocument


@when(
    parse_num(
        'add the document with subtype "{document}", sub type "{subType}", number "{number}" and name "{name}"'
    ),
    target_fixture="responseDocument",
)
def post_document(response, document, subType, number, name):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "type": document,
        "expiration_date": "2025-12-30",
        "emission_date": "2022-12-30T00:00:00Z",
        "sub_type": subType,
        "document_fields": {"number": number, "issue_date": "2010-01-01", "name": name},
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/document".format(profileID)

    responseDocument = requests.post(url=url, headers=header, data=payload)
    assert responseDocument.status_code == 201

    return responseDocument


@when(
    "add the file",
    target_fixture="responseFile",
)
def post_document_identification(responseDocument):
    responseJson = responseDocument.json()
    documentID = responseJson["document_id"]

    payload = "../support/upload/bexs.jpg"
    payload = json.dumps(payload, indent=4)

    header = {"Content-Type": "image/jpeg"}

    url = Config.registrationUrlInt + "/file?document_id={}".format(documentID)

    responseFile = requests.post(url=url, headers=header, data=payload)
    assert responseFile.status_code == 201

    return responseFile


@then(
    parse_num('I check the "{status}" compliance status'),
    target_fixture="complianceStatus",
)
def check_status_compliance(response, status):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/state/{}".format(profileID)

    complianceStatus = requests.get(url=url, headers=header, timeout=10)
    counter = 0

    while counter <= 30:
        complianceStatus = requests.get(url=url, headers=header)
        responseCompliance = complianceStatus.json()

        if (
            complianceStatus.status_code == 200
            and responseCompliance["result"] == status
        ):
            break
        else:
            counter += 1
            time.sleep(0.5)
    assert responseCompliance["result"] == status


@then(parsers.cfparse('I check the "{status}" status of the onboarding status'))
def check_approved_query(response, status):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temis_query + "/profile/{}".format(profileID)

    queryApproved = requests.get(url=url, headers=header)
    assert queryApproved.status_code == 200
    counter = 0

    while counter <= 20:
        queryApproved = requests.get(url=url, headers=header)
        approvedQuery = queryApproved.json()

        if (
            "onboarding_status" in approvedQuery
            and approvedQuery["onboarding_status"]["status"] == status
        ):
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    teste = approvedQuery["onboarding_status"]["status"]

    assert (
        approvedQuery["onboarding_status"]["status"] == status
    ), f"Esperado Status {status}, ocorrido {teste}"

    print("\nQuery Response:")
    print(queryApproved.json())


@then(parsers.cfparse("Limit {limitFX:d} assignment in temis query"))
def check_approved_query(response, limitFX):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temis_query + "/profile/{}".format(profileID)

    queryLimit = requests.get(url=url, headers=header)
    assert queryLimit.status_code == 200
    counter = 0

    while counter <= 20:
        queryLimit = requests.get(url=url, headers=header)
        periodicLimitdQuery = queryLimit.json()

        if periodicLimitdQuery["periodic_limits"][0]["amount"] == limitFX:
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    teste = periodicLimitdQuery["periodic_limits"][0]["amount"]

    assert (
        periodicLimitdQuery["periodic_limits"][0]["amount"] == limitFX
    ), f"Esperado Status {limitFX}, ocorrido {teste}"

    print("\nQuery Response:")
    print(queryLimit.json())


@when("check approved")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200
    responseJsonCheck = responseCheckApproved.json()
    assert responseJsonCheck["result"] == "APPROVED"


@then("check analysing")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200
    responseJsonCheck = responseCheckApproved.json()
    assert responseJsonCheck["result"] == "ANALYSING"


@then(
    "check that the callback was sent",
    target_fixture="responseCallback",
)
def check_approved_callback(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.callbackURL + "/{}".format(profileID)

    callbackApproved = requests.get(url=url, headers=header)
    assert callbackApproved.status_code == 200
    counter = 0

    responseValidation = {
        "entity_id": profileID,
        "engine_name": "PROFILE",
        "result": "APPROVED",
        "partner_id": "8c0c4081-b437-41c2-b21b-10490b018f41",
        "onboarding_status": {
            "status": "APPROVED",
            "status_reason": {
                "code": "profile_approved",
                "message": "profile approved",
            },
        },
    }

    while counter <= 200:
        callbackApproved = requests.get(url=url, headers=header)
        approvedQuery = callbackApproved.json()

        if responseValidation in approvedQuery:
            break
        else:
            counter += 1

    return callbackApproved


@when("add the address")
def post_addres(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "type": "LEGAL",
        "zip_code": "14222-888",
        "street": "Rua Maria Eugênia",
        "number": "456",
        "complement": "Perto da sorveteria",
        "neighborhood": "Paraíso",
        "city": "São Paulo",
        "state_code": "SP",
        "country_code": "BRA",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/address".format(profileID)

    responseAddres = requests.post(url=url, headers=header, data=payload)
    assert responseAddres.status_code == 201
    responseJson = responseAddres.json()
    assert responseJson["profile_id"] == profileID
    assert responseJson["type"] == "LEGAL"


@then("validated the creation of the internal account")
def check_approved_callback(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/account".format(profileID)

    accounts = requests.get(url=url, headers=header)
    counter = 0

    while counter <= 50:
        accounts = requests.get(url=url, headers=header)
        crateAccounts = accounts.json()

        if (
            crateAccounts["bank_code"] == "866"
            and crateAccounts["agency_number"] == "0001"
        ):
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    assert accounts.status_code == 200
    assert crateAccounts["bank_code"] == "866"
    assert crateAccounts["agency_number"] == "0001"


@when(
    "check what is missing in the profile so that it is approved",
)
def post_check_incomplete_profile(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    print(profileID)
    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)
    print(payload)
    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheck = requests.post(url=url, headers=header, data=payload)
    assert responseCheck.status_code == 200
    responseCHECKjson = responseCheck.json()
    print(responseCHECKjson)

    assert (
        responseCHECKjson["detailed_result"][0]["details"][0]["code"]
        == "ADDRESS_NOT_FOUND"
    )
    assert (
        responseCHECKjson["detailed_result"][0]["details"][1]["code"]
        == "DOCUMENT_NOT_FOUND_IDENTIFICATION"
    )


@when(
    "check for missing ADDRESS_NOT_FOUND , DOCUMENT_NOT_FOUND_IDENTIFICATION and PERSON_HAS_INSUFFICIENT_INCOME"
)
def post_check_incomplete_profile(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheck = requests.post(url=url, headers=header, data=payload)
    assert responseCheck.status_code == 200
    responseCHECK = responseCheck.json()

    assert (
        responseCHECK["detailed_result"][0]["details"][0]["code"] == "ADDRESS_NOT_FOUND"
    )
    assert (
        responseCHECK["detailed_result"][0]["details"][1]["code"]
        == "DOCUMENT_NOT_FOUND_IDENTIFICATION"
    )
    assert (
        responseCHECK["detailed_result"][0]["details"][2]["code"]
        == "PERSON_HAS_INSUFFICIENT_INCOME"
    )


@when(
    "check for missing EMAIL_REQUIRED , LAST_NAME_REQUIRED and DOCUMENT_NOT_FOUND_IDENTIFICATION"
)
def post_check_incomplete_profile(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheck = requests.post(url=url, headers=header, data=payload)
    assert responseCheck.status_code == 200
    responseCHECK = responseCheck.json()

    assert responseCHECK["detailed_result"][0]["details"][0]["code"] == "EMAIL_REQUIRED"
    assert (
        responseCHECK["detailed_result"][0]["details"][1]["code"]
        == "LAST_NAME_REQUIRED"
    )
    assert (
        responseCHECK["detailed_result"][0]["details"][2]["code"]
        == "DOCUMENT_NOT_FOUND_IDENTIFICATION"
    )


@when(
    "check for missing ADDRESS_NOT_FOUND , DOCUMENT_NOT_FOUND_IDENTIFICATION and DOCUMENT_NOT_FOUND_PROOF_OF_ADDRESS"
)
def post_check_incomplete_profile(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheck = requests.post(url=url, headers=header, data=payload)
    assert responseCheck.status_code == 200
    responseCHECK = responseCheck.json()

    assert (
        responseCHECK["detailed_result"][0]["details"][0]["code"] == "ADDRESS_NOT_FOUND"
    )
    assert (
        responseCHECK["detailed_result"][0]["details"][1]["code"]
        == "DOCUMENT_NOT_FOUND_IDENTIFICATION"
    )
    assert (
        responseCHECK["detailed_result"][0]["details"][2]["code"]
        == "DOCUMENT_NOT_FOUND_PROOF_OF_ADDRESS"
    )


@when("check for missing ADDRESS_NOT_FOUND and DOCUMENT_NOT_FOUND_CORPORATE_DOCUMENT")
def post_check_incomplete_profile_pj(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheck = requests.post(url=url, headers=header, data=payload)
    assert responseCheck.status_code == 200
    responseCHECK = responseCheck.json()

    assert (
        responseCHECK["detailed_result"][0]["details"][0]["code"] == "ADDRESS_NOT_FOUND"
    )
    assert (
        responseCHECK["detailed_result"][0]["details"][1]["code"]
        == "DOCUMENT_NOT_FOUND_CORPORATE_DOCUMENT"
    )


@then(
    "I verify that the profile is approved in compliance",
    target_fixture="complianceApproved",
)
def check_approved_compliance(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/state/{}".format(profileID)

    complianceApproved = requests.get(url=url, headers=header)
    assert complianceApproved.status_code == 200
    approvedCompliance = complianceApproved.json()
    assert approvedCompliance["entity_id"] == profileID
    assert approvedCompliance["result"] == "APPROVED"

    return complianceApproved


@then(
    "Check the data in the temis query",
    target_fixture="responseQuery",
)
def check_approved_query(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temis_query + "/profile/{}".format(profileID)

    queryApproved = requests.get(url=url, headers=header)
    assert queryApproved.status_code == 200
    counter = 0

    while counter <= 200:
        queryApproved = requests.get(url=url, headers=header)
        approvedQuery = queryApproved.json()

        if approvedQuery["onboarding_status"]["status"] == "APPROVED":
            break
        else:
            counter += 1

    return queryApproved


@given(parse_num('mock bureau "{mockName}"'), target_fixture="documentNumber")
def post_mock_bureau(mockName):
    documentNumber = utils.generate_cnpj()
    header = {
        "Content-Type": "application/json",
    }
    url = Config.bureau_mock_url + "/{}".format(documentNumber)
    payload = {"mock_name": mockName}
    payload = json.dumps(payload, indent=4)

    response = requests.post(url, headers=header, data=payload)

    return documentNumber


@given(parse_num('mock bureau PF "{mockName}"'), target_fixture="documentNumber")
def post_mock_bureau(mockName):
    documentNumber = utils.generate_cpf()
    header = {
        "Content-Type": "application/json",
    }
    url = Config.bureau_mock_url + "/{}".format(documentNumber)
    payload = {"mock_name": mockName}
    payload = json.dumps(payload, indent=4)

    response = requests.post(url, headers=header, data=payload)

    return documentNumber


@given(
    parse_num(
        'an individual customer PF with mock and partner "{partnerID}", offer "{offerType}", income {income:d}'
    ),
    target_fixture="response",
)
def post_ustomer_pf_mock(partnerID, offerType, income, documentNumber):
    idPartner = None
    idOffer = None

    if partnerID == "Revolut":
        idPartner = Config.Revolut
    if partnerID == "NUBANK":
        idPartner = Config.Nubank
    if partnerID == "NUBANK2":
        idPartner = Config.Nubank2
    if partnerID == "Susnstate":
        idPartner = Config.Susnstate
    if partnerID == "OpenSolo":
        idPartner = Config.OpenSolo
    if partnerID == "BexsBanco":
        idPartner = Config.BexsBanco
    if partnerID == "Pay":
        idPartner = Config.Pay
    if partnerID == "BoaCompra":
        idPartner = Config.BoaCompra
    if partnerID == "Dlocal":
        idPartner = Config.Dlocal
    if partnerID == "BlacklistPartner":
        idPartner = Config.BlacklistPartner
    if partnerID == "Keeta":
        idPartner = Config.Keeta
    if partnerID == "WatchlistPartner":
        idPartner = Config.WatchlistPartner

    if offerType == "DigitalTransfInvest":
        idOffer = Config.DigitalTransfInvest
    if offerType == "MaquininhaAPI":
        idOffer = Config.MaquininhaAPI
    if offerType == "MaquininhaCripto":
        idOffer = Config.MaquininhaCripto
    if offerType == "MaquininhaPortal":
        idOffer = Config.MaquininhaPortal
    if offerType == "WebpaymentMarketplace":
        idOffer = Config.WebpaymentMarketplace
    if offerType == "PayMyTuition":
        idOffer = Config.PayMyTuition
    if offerType == "Blacklist":
        idOffer = Config.Blacklist
    if offerType == "Watchlist":
        idOffer = Config.Watchlist

    payload = {
        "partner_id": idPartner,
        "offer_type": idOffer,
        "role_type": "CUSTOMER",
        "profile_type": "INDIVIDUAL",
        "document_number": documentNumber,
        "callback_url": config.Config.callbackURL,
        "email": "teste@teste.com",
        "individual": {
            "first_name": "Test",
            "last_name": "Digital",
            "date_of_birth": "1991-07-30T00:00:00Z",
            "income": income,
            "phones": [
                {
                    "type": "BUSINESS",
                    "number": "123",
                    "country_code": "55",
                    "area_code": "11",
                }
            ],
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    print(responsjson)
    assert response.status_code == 201

    return response


@when("that we update the annual income and assets values")
def patch_company_customer(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    payload = {
        "callback_url": config.Config.callbackURL,
        "company": {"annual_income": 1000.01, "assets": 123.45},
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}".format(profileID)

    responsePatch = requests.patch(url=url, headers=header, data=payload)
    assert responsePatch.status_code == 200
    responsePatchJson = responsePatch.json()

    assert responsePatchJson["company"]["annual_income"] == 1000.01
    assert responsePatchJson["company"]["assets"] == 123.45


@when("upadate in email and last name")
def put_customer(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    payload = {
        "email": "Some@email.com",
        "individual": {"last_name": "testeqa"},
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}".format(profileID)

    responsePatch = requests.patch(url=url, headers=header, data=payload)
    assert responsePatch.status_code == 200
    responsePatchJson = responsePatch.json()

    assert responsePatchJson["email"] == "Some@email.com"
    assert responsePatchJson["individual"]["last_name"] == "testeqa"


@when("we include a contact")
def post_fisrt_contact(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    documentNumber = utils.generate_cpf()

    payload = {
        "name": "Jose Bonifacio",
        "document_number": documentNumber,
        "email": "bonifacio.contact@gmail.com",
        "phone": "011988887777",
        "nationality": "BRA",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/contact".format(profileID)

    responseContact = requests.post(url=url, headers=header, data=payload)
    assert responseContact.status_code == 201
    responseContactJson = responseContact.json()

    assert responseContactJson["name"] == "Jose Bonifacio"


@when("create contract for invoice")
def post_contract(response, responseDocument):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    responseDocumenJson = responseDocument.json()
    documentID = responseDocumenJson["document_id"]

    payload = {
        "estimated_total_amount": 10000,
        "due_date": "2023-08-13",
        "profile_id": profileID,
        "document_id": documentID,
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/contract"

    responseContract = requests.post(url=url, headers=header, data=payload)
    assert responseContract.status_code == 201
    responseContractJson = responseContract.json()

    assert responseContractJson["result"] == "APPROVED"


@when(
    parse_num(
        'create override rule_set "{ruleSet}", rule_name "{ruleName}", result "{result}"'
    ),
    target_fixture="response",
)
def post_company_customer(response, ruleSet, ruleName, result):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "entity_id": profileID,
        "entity_type": "PROFILE",
        "rule_set": ruleSet,
        "rule_name": ruleName,
        "result": result,
        "comments": "Good guy!",
        "author": "your.username",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/override"

    response = requests.post(url=url, headers=header, data=payload)
    responsjson = response.json()
    print(responsjson)
    assert response.status_code == 200

    return response


@when("we include the second contact")
def post_second_contact(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    documentNumber = utils.generate_cpf()

    payload = {
        "name": "Maria Leopoldina",
        "document_number": documentNumber,
        "email": "leopoldina.contact@gmail.com",
        "phone": "011966665555",
        "nationality": "BRA",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/contact".format(profileID)

    responseContact = requests.post(url=url, headers=header, data=payload)
    assert responseContact.status_code == 201
    responseContactJson = responseContact.json()

    assert responseContactJson["name"] == "Maria Leopoldina"


@when(
    "we include the legal representative",
    target_fixture="responseRepresentativeLegal",
)
def post_legal_representative(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    documentNumber = utils.generate_cpf()

    payload = {
        "full_name": "John Doe",
        "document_number": documentNumber,
        "email": "aaa@gmail.com",
        "phone": "23455",
        "nationality": "BRA",
        "birth_date": "01/01/2000",
    }
    payload = json.dumps(payload, indent=4)

    header = {"Content-Type": "application/json"}

    url = Config.registrationUrlInt + "/profile/{}/legal-representative".format(
        profileID
    )

    responseRepresentativeLegal = requests.post(url=url, headers=header, data=payload)
    assert responseRepresentativeLegal.status_code == 201

    return responseRepresentativeLegal


@when(
    "we include the legal representative is pep",
    target_fixture="responseRepresentativeLegal",
)
def post_legal_representative(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    documentNumber = utils.generate_cpf()

    payload = {
        "full_name": "John Doe",
        "document_number": documentNumber,
        "email": "aaa@gmail.com",
        "phone": "23455",
        "nationality": "BRA",
        "birth_date": "01/01/2000",
        "pep": True,
    }
    payload = json.dumps(payload, indent=4)

    header = {"Content-Type": "application/json"}

    url = Config.registrationUrlInt + "/profile/{}/legal-representative".format(
        profileID
    )

    responseRepresentativeLegal = requests.post(url=url, headers=header, data=payload)
    assert responseRepresentativeLegal.status_code == 201

    return responseRepresentativeLegal


@when("we include the address for legal representative")
def post_addres_legal_representative(responseRepresentativeLegal):
    responseJson = responseRepresentativeLegal.json()
    legalRepresentativeID = responseJson["legal_representative_id"]

    payload = {
        "type": "LEGAL",
        "zip_code": "14222-111",
        "street": "Rua Maria Eugênia",
        "number": "456",
        "complement": "Perto da sorveteria",
        "neighborhood": "Paraíso",
        "city": "São Paulo",
        "state_code": "SP",
        "country_code": "BRA",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/legal-representative/{}/address".format(
        legalRepresentativeID
    )

    responseAddres = requests.post(url=url, headers=header, data=payload)
    assert responseAddres.status_code == 201


@when("we include the address for shareholder")
def post_addres_legal_representative(responseShareholder):
    responseJson = responseShareholder.json()
    shareholderID = responseJson["shareholder_id"]

    payload = {
        "type": "LEGAL",
        "zip_code": "14222-111",
        "street": "Rua Maria Eugênia",
        "number": "456",
        "complement": "Perto da sorveteria",
        "neighborhood": "Paraíso",
        "city": "São Paulo",
        "state_code": "SP",
        "country_code": "BRA",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/shareholder/{}/address".format(shareholderID)

    responseAddres = requests.post(url=url, headers=header, data=payload)
    assert responseAddres.status_code == 201


@when(
    parse_num("I include a shareholder with percent {percent:d}"),
    target_fixture="responseShareholder",
)
def post_share_holder(response, percent):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    documentNumber = utils.generate_cpf()

    payload = {
        "full_name": "Test",
        "document_number": documentNumber,
        "nationality": "BRA",
        "ownership_percent": percent,
        "date_of_birth": "01/01/2000",
        "person_type": "INDIVIDUAL",
        "level": 1,
    }
    payload = json.dumps(payload, indent=4)

    header = {"Content-Type": "application/json"}

    url = Config.registrationUrlInt + "/profile/{}/shareholders".format(profileID)

    responseShareholder = requests.post(url=url, headers=header, data=payload)
    responseJsonShareholder = responseShareholder.json()

    assert responseShareholder.status_code == 201
    assert responseJsonShareholder["ownership_percent"] == percent

    return responseShareholder


@then("I verify that there is no limit for this profile")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.limitUrlInt + "/profile/{}".format(profileID)

    limiteResponse = requests.get(url=url, headers=header)
    assert limiteResponse.status_code == 404


@when("I update the legal representative")
def patch_company_customer(responseRepresentativeLegal):
    responseJson = responseRepresentativeLegal.json()
    legalRepresentativeID = responseJson["legal_representative_id"]

    payload = {"full_name": "TestqaPYTHON"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/legal-representative/{}".format(
        legalRepresentativeID
    )

    responsePatch = requests.patch(url=url, headers=header, data=payload)
    assert responsePatch.status_code == 200
    responsePatchJson = responsePatch.json()

    assert responsePatchJson["full_name"] == "TestqaPYTHON"


@when(
    parse_num(
        'I enclose the "{document}", sub type "{subType}", number "{number}" and name "{name}" for the legal representative'
    ),
    target_fixture="responseDocumentLegalRepresentative",
)
def post_document_identification(
    responseRepresentativeLegal,
    document,
    subType,
    number,
    name,
):
    responseJson = responseRepresentativeLegal.json()
    legalRepresentativeID = responseJson["legal_representative_id"]

    payload = {
        "type": document,
        "expiration_date": "2025-12-30",
        "emission_date": "2022-12-30T00:00:00Z",
        "sub_type": subType,
        "document_fields": {"number": number, "issue_date": "2010-01-01", "name": name},
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/legal-representative/{}/document".format(
        legalRepresentativeID
    )

    responseDocumentLegalRepresentative = requests.post(
        url=url, headers=header, data=payload
    )
    assert responseDocumentLegalRepresentative.status_code == 201

    return responseDocumentLegalRepresentative


@when("add the file in document for legal representative")
def post_document_identification(responseDocumentLegalRepresentative):
    responseJson = responseDocumentLegalRepresentative.json()
    documentID = responseJson["document_id"]

    payload = "../support/upload/bexs.jpg"
    payload = json.dumps(payload, indent=4)

    header = {"Content-Type": "image/jpeg"}

    url = Config.registrationUrlInt + "/file?document_id={}".format(documentID)

    responseFile = requests.post(url=url, headers=header, data=payload)
    assert responseFile.status_code == 201


@when("check compliance not aproved Shareholder minimum required")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200
    responseJsonCheck = responseCheckApproved.json()
    assert (
        responseJsonCheck["detailed_result"][0]["details"][0]["code"]
        == "SHAREHOLDING_NOT_ACHIEVE_MINIMUM_REQUIRED"
    )


@when("check compliance not aproved legal representative")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {"entity_type": "PROFILE"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/check/{}".format(profileID)

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200
    responseJsonCheck = responseCheckApproved.json()
    assert (
        responseJsonCheck["detailed_result"][0]["details"][0]["code"]
        == "LEGAL_REPRESENTATIVE_NOT_APPROVED"
    )


@when("Override in Compliance")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "entity_id": profileID,
        "entity_type": "PROFILE",
        "rule_set": "SERASA_BUREAU",
        "rule_name": "CUSTOMER_HAS_PROBLEMS_IN_SERASA",
        "result": "APPROVED",
        "comments": "Good guy!",
        "author": "your.username",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/override"

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200


@when("Approve rule manual validation")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "entity_id": profileID,
        "entity_type": "PROFILE",
        "rule_set": "MANUAL_VALIDATION",
        "rule_name": "PROFILE_DATA",
        "result": "APPROVED",
        "comments": "Good guy!",
        "author": "your.username",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/override"

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200


@when("Override of ownership structure")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "entity_id": profileID,
        "entity_type": "PROFILE",
        "rule_set": "OWNERSHIP_STRUCTURE",
        "rule_name": "SHAREHOLDING",
        "result": "APPROVED",
        "comments": "Good guy!",
        "author": "your.username",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/override"

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200


@then("I check that the profile is not eligible for the custom limit")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.limitUrlInt + "/profile/{}".format(profileID)

    limiteResponse = requests.get(url=url, headers=header)
    assert limiteResponse.status_code == 200
    responseJsonLimit = limiteResponse.json()

    assert responseJsonLimit["custom_limit_eligibility"] == []


@then(parse_num("check assigned limit {limit:d}"))
def check_not_limit(response, limit):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.limitUrlInt + "/periodic?profile_id={}".format(profileID)

    limiteResponse = requests.get(url=url, headers=header)
    limitResponsejson = limiteResponse.json()
    print(limitResponsejson)
    counter = 0

    responseValidation = {
        "profile_id": profileID,
        "operation_type": "GENERAL",
        "amount": limit,
        "periodic_limit_type": "STANDARD",
        "author": "StandardLimitManager",
        "version": 0,
        "auto_renew": True,
    }

    while counter <= 10:
        limiteResponse = requests.get(url=url, headers=header)
        responseLimitJson = limiteResponse.json()

        if responseValidation not in responseLimitJson:
            counter += 1
        else:
            break

    assert limiteResponse.status_code == 200
    if limit == "6000":
        assert limitResponsejson[0]["amount"] == limit
    if limit == "10000":
        assert limitResponsejson[0]["amount"] == limit
    if limit == "100000":
        assert limitResponsejson[0]["amount"] == limit
    if limit == "120000":
        assert limitResponsejson[1]["amount"] == limit
    if limit == "20000":
        assert limitResponsejson[1]["amount"] == limit


@then(parse_num("I check the assigned limit {limitFX:d} in Fx integrator"))
def check_not_limit(response, limitFX):
    responseJson = response.json()
    documentNumber = responseJson["document_number"]
    partnerID = responseJson["partner_id"]
    offerID = responseJson["offer_type"]

    header = {
        "Content-Type": "application/json",
    }

    url = (
        Config.fxIntegratorUrlInt
        + "/limit?document_number={}&partner_id={}&offer_id={}".format(
            documentNumber, partnerID, offerID
        )
    )

    limiteResponseFX = requests.get(url=url, headers=header)
    responseLimitFXJson = limiteResponseFX.json()
    counter = 0

    while counter <= 50:
        limiteResponseFX = requests.get(url=url, headers=header)
        responseLimitFXJson = limiteResponseFX.json()
        print(responseLimitFXJson)

        if (
            responseLimitFXJson[0]["amount"] == limitFX
            and responseLimitFXJson[0]["operation_type"] == "GENERAL"
        ):
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    assert limiteResponseFX.status_code == 200
    assert responseLimitFXJson[0]["amount"] == limitFX


@then("I check eligibility for custom limit")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.limitUrlInt + "/profile/{}".format(profileID)

    limiteResponse = requests.get(url=url, headers=header)
    assert limiteResponse.status_code == 200
    counter = 0

    responseValidation = {
        "operation_type": "GENERAL",
        "eligible": True,
        "pending": True,
    }

    while counter <= 20:
        limiteResponse = requests.get(url=url, headers=header)
        responseLimitJson = limiteResponse.json()

        if responseValidation in responseLimitJson["custom_limit_eligibility"]:
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    assert responseLimitJson["custom_limit_eligibility"][0]["eligible"] == True


@when("I assign the custom limit")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "profile_id": profileID,
        "operation_type": "GENERAL",
        "end_date": "2024-07-25T12:24:27.148Z",
        "amount": 200000,
        "periodic_limit_type": "CUSTOM",
        "author": "Author X",
        "comments": "Comment Y",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.limitUrlInt + "/periodic/"

    limiteResponse = requests.post(url=url, headers=header, data=payload)
    assert limiteResponse.status_code == 201


@then("I check if the eligibility flag is False")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.limitUrlInt + "/profile/{}".format(profileID)

    limiteResponse = requests.get(url=url, headers=header)
    assert limiteResponse.status_code == 200
    responseLimitJson = limiteResponse.json()

    for i in responseLimitJson["custom_limit_eligibility"]:
        if i["pending"] == False:
            break

    assert responseLimitJson["custom_limit_eligibility"][0]["pending"] == False


@then("I check the assigned custom limit")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    print(profileID)

    responseValidation = {
        "profile_id": profileID,
        "operation_type": "GENERAL",
        "end_date": "2024-07-25T00:00:00Z",
        "amount": 200000,
        "periodic_limit_type": "CUSTOM",
        "author": "Author X",
        "comments": "Comment Y",
    }

    header = {
        "Content-Type": "application/json",
    }

    url = Config.limitUrlInt + "/periodic?profile_id={}".format(profileID)

    limiteResponse = requests.get(url=url, headers=header)
    assert limiteResponse.status_code == 200
    counter = 0

    while counter <= 10:
        limiteResponse = requests.get(url=url, headers=header)
        responseLimitJson = limiteResponse.json()

        if responseValidation in responseLimitJson:
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)


@when("I include the contact")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "name": "Test",
        "document_number": utils.generate_cpf(),
        "nationality": "BR",
        "email": "Test@",
        "phone": "123",
        "phones": [
            {
                "type": "MOBILE",
                "number": "988776655",
                "country_code": "55",
                "area_code": "11",
            },
            {
                "type": "RESIDENTIAL",
                "number": "55443322",
                "country_code": "55",
                "area_code": "11",
            },
            {
                "type": "BUSINESS",
                "number": "22331100",
                "country_code": "55",
                "area_code": "11",
            },
        ],
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/contact".format(profileID)

    limiteResponse = requests.post(url=url, headers=header, data=payload)
    assert limiteResponse.status_code == 201


@when("I include the question forms")
def check_not_limit(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "form_name": "SOME NAME",
        "questions": [
            {
                "code": "QUESTION_TYPE_1",
                "answer": "None",
                "comments": "Nothing to comment",
            }
        ],
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}/question-form".format(profileID)

    limiteResponse = requests.post(url=url, headers=header, data=payload)
    assert limiteResponse.status_code == 201


@when(
    parsers.cfparse(
        "creates profile {person_type} with role type {role_type} offer {offer} and partner {partner}"
    ),
    target_fixture="response",
)
def post_individual_counterparty(person_type, role_type, offer, partner):
    payload = {
        "partner_id": partner,
        "offer_type": offer,
        "role_type": role_type,
        "profile_type": person_type,
        "email": "teste@teste.com",
    }

    if person_type == "INDIVIDUAL":
        payload["document_number"] = utils.generate_cpf()
        payload["individual"] = {
            "first_name": "Test",
            "last_name": "Digital",
            "date_of_birth": "1991-07-30T00:00:00Z",
            "phones": [
                {
                    "type": "BUSINESS",
                    "number": "123",
                    "country_code": "55",
                    "area_code": "11",
                }
            ],
        }
    elif person_type == "COMPANY":
        payload["document_number"] = utils.generate_cnpj()
        payload["company"] = {
            "legal_name": "Some legal name",
        }

    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile"

    response = requests.post(url=url, headers=header, data=payload)

    return response


@when("is manually approved")
def post_check(response):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    payload = {
        "entity_id": profileID,
        "entity_type": "PROFILE",
        "rule_set": "MANUAL_VALIDATION",
        "rule_name": "PROFILE_DATA",
        "result": "APPROVED",
        "comments": "manually approved by user",
        "author": "your.username",
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/override"

    responseCheckApproved = requests.post(url=url, headers=header, data=payload)
    assert responseCheckApproved.status_code == 200
