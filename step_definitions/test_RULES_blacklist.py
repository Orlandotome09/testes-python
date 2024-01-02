import requests
from functools import partial
from pytest_bdd import scenarios, given, then, when, parsers
from support import utils
from support import config
from support.config import Config
import json
import time

scenarios("../features/rules/blacklist.feature")

EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)


@given(
    parse_num("create partner"),
    target_fixture="responsePartner",
)
def post_partner_blacklist():
    payload = {
        "partner_id": "dcf3ecc1-b160-48b7-8936-10b184f8fac8",
        "document_number": "123456",
        "name": "TESTE_BLACKLIST_RULE",
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
    parse_num("create offer"),
    target_fixture="responseOffer",
)
def post_offer_blacklist():
    payload = {"offer_type": "TESTE_BLACKLIST_RULE", "product": "Test"}
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.registrationUrlInt + "/offers"

    responseOffer = requests.post(url=url, headers=header, data=payload)

    return responseOffer


@given(
    parse_num("create catalog blacklist PF"),
    target_fixture="responseCatalogPF",
)
def post_catalog_blacklist(responseOffer):
    responseJsonOffer = responseOffer.json()
    offerID = responseJsonOffer["offer_type"]
    configID = "ec86249c-9c7a-5ca5-9686-d1c101e1bd2c"

    payload = {
        "offer_type": offerID,
        "role_type": "CUSTOMER",
        "person_type": "INDIVIDUAL",
        "pre_validation_rule_set_config_id": "",
        "validation_steps": [
            {
                "skip_for_approval": False,
                "rules_config": {"blacklist": {}},
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

    responseConfiggPF = requests.put(url=url, headers=header, data=payload)
    assert responseConfiggPF.status_code == 200

    return responseConfiggPF


@given(
    parse_num("create catalog blacklist PJ"),
    target_fixture="responseCatalogPJ",
)
def post_catalog_blacklist(responseOffer):
    responseJsonOffer = responseOffer.json()
    offerID = responseJsonOffer["offer_type"]
    configID = "fc9b0efe-5bca-57c7-8e66-6b7963211546"

    payload = {
        "offer_type": offerID,
        "role_type": "CUSTOMER",
        "person_type": "COMPANY",
        "pre_validation_rule_set_config_id": "",
        "validation_steps": [
            {
                "skip_for_approval": False,
                "rules_config": {"blacklist": {}},
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

    responseConfigPJ = requests.put(url=url, headers=header, data=payload)
    assert responseConfigPJ.status_code == 200

    return responseConfigPJ


@given(
    parse_num(
        'document present in internal list with fuill name "{fullName}" and person type "{personType}"'
    ),
    target_fixture="documentNumber",
)
def post_restrictive_list(fullName, personType):
    documentNumber = None

    if fullName == "Test Blacklist PF":
        documentNumber = utils.generate_cpf()
    if fullName == "Test Blacklist PJ":
        documentNumber = utils.generate_cnpj()

    payload = {
        "justification": "Present Black List",
        "full_name": fullName,
        "document_number": documentNumber,
        "person_type": personType,
    }
    payload = json.dumps(payload, indent=4)

    header = {
        "Content-Type": "application/json",
    }

    url = Config.temis_restrictive_list + "/internal-list"

    response = requests.post(url=url, headers=header, data=payload)

    return documentNumber


@then(
    parse_num('I check the "{status}" compliance status black list'),
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
    assert responseCompliance["rule_set_result"][0]["set"] == "BLACKLIST"
    assert responseCompliance["rule_set_result"][0]["name"] == "BLACKLIST"
    assert responseCompliance["rule_set_result"][0]["result"] == status
