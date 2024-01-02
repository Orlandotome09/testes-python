import requests
from functools import partial
from pytest_bdd import scenarios, given, then, when, parsers
from support import utils
from support import config
from support.config import Config
import json
import time


scenarios(
    "../features/api/registration/documents/profile.feature",
)

EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)


@given(
    parse_num("a PJ profile"),
    target_fixture="response",
)
def post_company_customer():
    payload = {
        "partner_id": config.Config.OpenSolo,
        "offer_type": config.Config.MaquininhaAPI,
        "role_type": "CUSTOMER",
        "profile_type": "COMPANY",
        "document_number": utils.generate_cnpj(),
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
    parse_num('create a profile document of the type "{type}"'),
    target_fixture="responseDOCUMENT",
)
def post_document_share_holder(response, type):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    print(profileID)
    payload = {"type": type}
    payload = json.dumps(payload, indent=4)
    print(payload)
    header = {"Content-Type": "application/json"}

    url = Config.registrationUrlInt + "/profile/{}/document".format(profileID)
    print(url)
    responseDOCUMENT = requests.post(url=url, headers=header, data=payload)

    assert responseDOCUMENT.status_code == 201

    return responseDOCUMENT


@when(
    "add the file in profile",
    target_fixture="responseFile",
)
def post_document_identification(responseDOCUMENT):
    responseJson = responseDOCUMENT.json()
    documentID = responseJson["document_id"]

    payload = "../support/upload/bexs.jpg"
    payload = json.dumps(payload, indent=4)

    header = {"Content-Type": "image/jpeg"}

    url = Config.registrationUrlInt + "/file?document_id={}".format(documentID)

    responseFile = requests.post(url=url, headers=header, data=payload)
    assert responseFile.status_code == 201

    return responseFile


@then(parse_num('then I see the document created "{expected}"'))
def check_document(responseDOCUMENT, expected):
    responseJson = responseDOCUMENT.json()
    documentID = responseJson["document_id"]
    print(documentID)
    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/document/{}".format(documentID)

    documentGet = requests.get(url=url, headers=header, timeout=10)
    counter = 0

    while counter <= 30:
        documentGet = requests.get(url=url, headers=header)
        responseGetDocument = documentGet.json()

        if documentGet.status_code == 200 and responseGetDocument["type"] == expected:
            break
        else:
            counter += 1
            time.sleep(0.5)

    assert responseGetDocument["type"] == expected


@then(parse_num("then I see the documentFile created"))
def check_documentFile(responseDOCUMENT):
    responseJson = responseDOCUMENT.json()
    documentID = responseJson["document_id"]
    print(documentID)
    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/document/{}/files".format(documentID)
    print(url)
    documentGet = requests.get(url=url, headers=header)
    assert documentGet.status_code == 200


@then(parsers.cfparse("check documentfile in temis query"))
def check_document_query(response, responseDOCUMENT):
    responseJson = response.json()
    profileID = responseJson["profile_id"]
    responseJsonShareholder = responseDOCUMENT.json()
    documentID = responseJsonShareholder["document_id"]

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

        if approvedQuery["documents"][0]["document_id"] == documentID:
            time.sleep(2)
            break
        else:
            counter += 1
            time.sleep(0.5)

    print("\nQuery Response:")
    print(queryApproved.json())
