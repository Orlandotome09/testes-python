import requests
from functools import partial
from pytest_bdd import scenarios, given, then, when, parsers
from support import utils
from support import config
from support.config import Config
import json
import time

scenarios("../features/rules/watchlist.feature")

EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)


@given(
    parse_num("create partner Watchlist"),
    target_fixture="responsePartner",
)
def post_partner_watchlist():
    payload = {
        "partner_id": "cd7a5cdc-5a8e-42ad-91c5-450558521599",
        "document_number": "759687",
        "name": "TestWatchlistRulePartner",
        "logo_image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Emblem_from_the_Brazilian_Air_Force_during_WWII.jpg/260px-Emblem_from_the_Brazilian_Air_Force_during_WWII.jpg",
        "status": "ACTIVE",
        "config": {"customer_segregation_type": "BY_PARTNER", "use_callback_v2": True},
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/partners"

    responsePartner = requests.post(url=url, headers=header, data=payload)

    return responsePartner


@given(
    parse_num("create offer Watchlist"),
    target_fixture="responseOffer",
)
def post_offer_watchlist():
    payload = {"offer_type": "TEST_WATCHLIST_RULE", "product": "maquininha"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/offers"

    responseOffer = requests.post(url=url, headers=header, data=payload)

    return responseOffer


@given(
    parse_num("create config Watchlist PF"),
    target_fixture="responseCatalogPF",
)
def CONFIG_watchlist_PF(responseOffer):
    responseJsonOffer = responseOffer.json()
    offerID = responseJsonOffer["offer_type"]
    configID = "7fa2d26f-3abc-56f3-bce3-8bcd07404824"

    payload = {
        "offer_type": offerID,
        "role_type": "CUSTOMER",
        "person_type": "INDIVIDUAL",
        "pre_validation_rule_set_config_id": "",
        "validation_steps": [
            {
                "skip_for_approval": False,
                "rules_config": {
                    "pep": {},
                    "watchlist": {
                        "want_pep_tag": True,
                        "wanted_sources": ["ADVERSE_MEDIA", "ASSOCIATED_ENTITY", "PEP"],
                    },
                },
            }
        ],
        "product_config": {
            "create_bexs_account": False,
            "tree_integration": False,
            "enrich_profile_with_bureau_data": False,
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temisConfigUrl + "/cadastral-validation-config/{}".format(configID)

    responseCONFIGgPF = requests.put(url=url, headers=header, data=payload)

    return responseCONFIGgPF


@given(
    parse_num("create config Watchlist PJ"),
    target_fixture="responseCatalogPJ",
)
def CONFIG_watchlist_pj(responseOffer):
    responseJsonOffer = responseOffer.json()
    offerID = responseJsonOffer["offer_type"]
    configID = "46776580-d968-58e9-9988-814f7d1a16a5"

    payload = {
        "offer_type": offerID,
        "role_type": "CUSTOMER",
        "person_type": "COMPANY",
        "pre_validation_rule_set_config_id": "",
        "validation_steps": [
            {
                "skip_for_approval": False,
                "rules_config": {
                    "watchlist": {
                        "want_pep_tag": True,
                        "wanted_sources": ["ADVERSE_MEDIA", "ASSOCIATED_ENTITY"],
                    }
                },
            }
        ],
        "product_config": {
            "create_bexs_account": False,
            "tree_integration": False,
            "enrich_profile_with_bureau_data": False,
        },
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temisConfigUrl + "/cadastral-validation-config/{}".format(configID)

    responseCONFIGPJ = requests.put(url=url, headers=header, data=payload)
    assert responseCONFIGPJ.status_code == 200

    return responseCONFIGPJ


@given(
    parse_num("document present in Watchlist PF"),
    target_fixture="documentNumber",
)
def post_restrictive_list():
    documentNumber = utils.generate_cpf()

    payload = {
        "document_number": documentNumber,
        "title": "SomeToken",
        "name": "Someone",
        "link": "/link",
        "watch": "",
        "other": "",
        "entries": ["someEntry"],
        "sources": ["Adverse Media", "Enforcement"],
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temis_mock + "/compliance/watchlist"

    response = requests.post(url=url, headers=header, data=payload)
    assert response.status_code == 201

    return documentNumber


@given(
    parse_num("document present in Watchlist PJ"),
    target_fixture="documentNumber",
)
def post_restrictive_list():
    documentNumber = utils.generate_cnpj()
    companyName = "SomeCompanyNamePresent"

    payload = {
        "title": "SomeToken",
        "name": "Someone",
        "link": "/link",
        "watch": "",
        "other": "",
        "entries": ["someEntry"],
        "sources": ["Adverse Media", "Enforcement"],
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temis_mock + "/compliance/watchlist/company/{}".format(companyName)

    response = requests.post(url=url, headers=header, data=payload)
    assert response.status_code == 201 or 409

    return documentNumber


@then(
    parse_num('I check the "{status}" compliance status Watchlist'),
    target_fixture="complianceStatus",
)
def check_status_compliance(response, status):
    responseJson = response.json()
    profileID = responseJson["profile_id"]

    header = {
        "Content-Type": "application/json",
    }

    url = Config.complianceUrlInt + "/state/{}".format(profileID)

    complianceStatus = requests.get(url=url, headers=header)
    counter = 0

    while counter <= 100:
        complianceStatus = requests.get(url=url, headers=header)
        responseCompliance = complianceStatus.json()

        if (
            complianceStatus.status_code == 200
            and responseCompliance["result"] == status
        ):
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    assert responseCompliance["result"] == status
    assert responseCompliance["rule_set_result"][0]["set"] == "WATCHLIST"
    assert responseCompliance["rule_set_result"][0]["name"] == "WATCHLIST"
    assert responseCompliance["rule_set_result"][0]["result"] == status
    assert (
        responseCompliance["rule_set_result"][0]["problems"][0]["code"]
        == "PERSON_FOUND_ON_WATCHLIST"
    )


@given(
    parse_num(
        'create customer PJ with partner "{partnerID}", offer "{offerType}" and legal name "{legalName}"'
    ),
    target_fixture="response",
)
def post_company_customer(documentNumber, partnerID, offerType, legalName):
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
        "profile_type": "COMPANY",
        "document_number": documentNumber,
        "callback_url": config.Config.callbackURL,
        "company": {
            "legal_name": legalName,
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
