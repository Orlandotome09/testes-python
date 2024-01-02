import requests
from functools import partial
from pytest_bdd import scenarios, given, then, when, parsers
from support import utils
from support import config
from support.config import Config
import json
import time

scenarios("../features/api/registration/complement_of_nature.feature")

EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)


@given(
    parse_num(
        'an individual customer PF with partner "{partnerID}", offer "{offerType}", income {income:d} and complement of nature "{complementNature}"'
    ),
    target_fixture="response",
)
def post_individual_customer(partnerID, offerType, income, complementNature):
    idPartner = None
    idOffer = None
    print(complementNature)

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
        "role_type": "CUSTOMER",
        "profile_type": "INDIVIDUAL",
        "document_number": utils.generate_cpf(),
        "callback_url": config.Config.callbackURL,
        "email": "teste@teste.com",
        "bacen_classification_type": complementNature,
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
    responsejson = response.json()
    print(responsejson)

    return response


@then(parsers.cfparse('I receive a "{status_code:d}" status code'))
def assert_status_code(response, status_code):
    assert response.status_code == status_code


@then(
    parsers.cfparse(
        'I check the bacen_classification_type in temis query "{complementNature}"'
    )
)
def check_approved_query(response, complementNature):
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
            queryApproved.status_code == 200
            and approvedQuery["bacen_classification_type"] == complementNature
        ):
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    assert approvedQuery["bacen_classification_type"] == complementNature

    print("\nQuery Response:")
    print(queryApproved.json())


@given(
    parsers.cfparse(
        'create counterparty PF with complement of nature "{complementNature}"'
    ),
    target_fixture="response",
)
def post_individual_counterparty(complementNature):
    payload = {
        "partner_id": "67ca469e-143f-4867-b182-4ac9bdc4f111",
        "offer_type": "MAQUININHA_API_01",
        "role_type": "COUNTERPARTY",
        "profile_type": "INDIVIDUAL",
        "document_number": utils.generate_cpf(),
        "email": "teste@teste.com",
        "bacen_classification_type": complementNature,
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

    return response


@given(
    parsers.cfparse(
        'create counterparty PJ with complement of nature "{complementNature}"',
    ),
    target_fixture="response",
)
def post_individual_customer(complementNature):
    payload = {
        "partner_id": "67ca469e-143f-4867-b182-4ac9bdc4f111",
        "offer_type": "MAQUININHA_API_01",
        "role_type": "COUNTERPARTY",
        "profile_type": "COMPANY",
        "document_number": utils.generate_cnpj(),
        "bacen_classification_type": complementNature,
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

    return response


@given(
    parse_num(
        'create customer PJ with partner "{partnerID}", offer "{offerType}" and complement of nature "{complementNature}"'
    ),
    target_fixture="response",
)
def post_company_customer(partnerID, offerType, complementNature):
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
        "role_type": "CUSTOMER",
        "profile_type": "COMPANY",
        "document_number": utils.generate_cnpj(),
        "callback_url": config.Config.callbackURL,
        "bacen_classification_type": complementNature,
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
    parse_num('patch in complement of nature "{complementNature}"'),
)
def put_customer(response, complementNature):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    payload = {
        "bacen_classification_type": complementNature,
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/profile/{}".format(profileID)

    responsePatch = requests.patch(url=url, headers=header, data=payload)
    assert responsePatch.status_code == 200
    responsePatchJson = responsePatch.json()

    assert responsePatchJson["bacen_classification_type"] == complementNature


@when(
    parse_num('UPDATE complement of nature "{complementNature}"'),
    target_fixture="response",
)
def PUT_company_customer(response, complementNature):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    partnerID = responseJson["partner_id"]
    offerID = responseJson["offer_type"]
    documentNumber = responseJson["document_number"]

    payload = {
        "partner_id": partnerID,
        "offer_type": offerID,
        "role_type": "CUSTOMER",
        "profile_type": "COMPANY",
        "document_number": documentNumber,
        "bacen_classification_type": complementNature,
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

    url = Config.registrationUrlInt + "/profile/{}".format(profileID)

    response = requests.put(url=url, headers=header, data=payload)
    assert response.status_code == 200

    return response


@given(
    parse_num('create Merchant PJ with complement of nature "{complementNature}"'),
    target_fixture="response",
)
def post_company_customer(complementNature):
    payload = {
        "partner_id": Config.Pay,
        "offer_type": Config.PayMyTuition,
        "role_type": "MERCHANT",
        "profile_type": "COMPANY",
        "document_number": utils.generate_cnpj(),
        "callback_url": config.Config.callbackURL,
        "bacen_classification_type": complementNature,
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
    responseJson = response.json()
    assert responseJson["bacen_classification_type"] == ""

    return response
