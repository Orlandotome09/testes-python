import os, json, requests, time
from dotenv import load_dotenv

from pathlib import Path

load_dotenv()
ENV = os.getenv("ENVIRONMENT")


if ENV == "dev":
    BUREAU_MOCK_URL = "https://bureau-mock.bexs.com.br/mock"
    BUREAU_URL = "http://bureau-development.bexs.com.br/v1/bureau"
    REGISTRATION_URL_INT = "https://api-dev.bexs.com.br/v1/temis"
    COMPLIANCE_URL_INT = "https://api-dev.bexs.com.br/compliance-int"
    LIMIT_URL_INT = "https://api-dev.bexs.com.br/limit-int"
    FX_INTEGRATOR_URL_INT = "https://api-dev.bexs.com.br/fx-integrator"
    REGISTRATION_URL_EXT = "https://api-dev.bexs.com.br/temis"
    COMPLIANCE_URL_EXT = "https://api-dev.bexs.com.br/compliance"
    LIMIT_URL_EXT = "https://api-dev.bexs.com.br/limit"
    CALLBACK_URL = "https://api-dev.bexs.com.br/temis-mocks/callback"
    AUTH_URL = "https://forex2.bexs.com.br/v1/auth/token"
    TEMIS_MOCK = "https://api-dev.bexs.com.br/temis-mocks"
    ENRICHMENT = "https://api-dev.bexs.com.br/temis-enrichment"
    TEMIS_QUERY = "https://api-dev.bexs.com.br/temis-query"
    TEMIS_RESTRICTIVE_LIST = "https://api-dev.bexs.com.br/temis-restrictive-lists"
    TEMIS_CONFIG_URL = "https://api-dev.bexs.com.br/temis-config"
    TEMIS_COMPLIANCE_ACTION = "https://api-dev.bexs.com.br/temis-compliance-action"
    TEMIS_TAS_URL = "https://api-dev.bexs.com.br/temis-tas-integrator/tas-file"
    TEMIS_BUREAU_URL = "https://api-dev.bexs.com.br/temis-bureau"


elif ENV == "sandbox":
    BUREAU_MOCK_URL = "https://bureau-mock.bexs.com.br/mock"
    BUREAU_URL = "http://bureau-development.bexs.com.br/v1/bureau"
    REGISTRATION_URL_INT = "https://api-sandbox.bexs.com.br/v1/temis"
    COMPLIANCE_URL_INT = "https://api-sandbox.bexs.com.br/compliance-int"
    LIMIT_URL_INT = "https://api-sandbox.bexs.com.br/limit-int"
    FX_INTEGRATOR_URL_INT = "https://api-sandbox.bexs.com.br/fx-integrator"
    REGISTRATION_URL_EXT = "https://api-sandbox.bexs.com.br/temis"
    COMPLIANCE_URL_EXT = "https://api-sandbox.bexs.com.br/compliance"
    LIMIT_URL_EXT = "https://api-sandbox.bexs.com.br/limit"
    CALLBACK_URL = "https://api-dev.bexs.com.br/temis-mocks/callback"
    AUTH_URL = "https://forex2.bexs.com.br/v1/auth/token"
    TEMIS_MOCK = "https://api-sandbox.bexs.com.br/temis-mocks"
    ENRICHMENT = "https://api-sandbox.bexs.com.br/temis-enrichment"
    TEMIS_COMPLIANCE_ACTION = "https://api-sandbox.bexs.com.br/temis-compliance-action"
    TEMIS_TAS_URL = "https://api-sandbox.bexs.com.br/temis-tas-integrator/tas-file"
    TEMIS_BUREAU_URL = "https://api-sandbox.bexs.com.br/temis-bureau"


def mock_tas_files(fileDate, fileContent):
    header = {"Content-Type": "application/json"}
    payload = {"date": fileDate, "file_content": fileContent}

    payload = json.dumps(payload, indent=4)
    url = TEMIS_MOCK + "/tas/file"

    return requests.post(url, headers=header, data=payload)


def process_tas_files(documentType, fileDate):
    header = {"Content-Type": "application/json"}
    payload = {"document_type": documentType, "file_date": fileDate}

    payload = json.dumps(payload, indent=4)
    url = TEMIS_TAS_URL + "/process"

    response = requests.post(url, headers=header, data=payload)

    time.sleep(5)

    return response


def get_bureau_individual(documentNumber):
    header = {"Content-Type": "application/json"}
    url = TEMIS_BUREAU_URL + "/individual/{}".format(documentNumber)
    return requests.get(url, headers=header)


def get_bureau_company(documentNumber):
    header = {"Content-Type": "application/json"}
    url = TEMIS_BUREAU_URL + "/company/{}".format(documentNumber)
    return requests.get(url, headers=header)


class Config:
    bureau_mock_url = BUREAU_MOCK_URL
    bureau_url = BUREAU_URL
    temis_compliance_action = TEMIS_COMPLIANCE_ACTION
    temis_restrictive_list = TEMIS_RESTRICTIVE_LIST
    temis_query = TEMIS_QUERY
    temis_enrichment = ENRICHMENT
    temis_tas_url = TEMIS_TAS_URL
    temis_bureau_url = TEMIS_BUREAU_URL
    temis_mock = TEMIS_MOCK
    temisConfigUrl = TEMIS_CONFIG_URL
    registrationUrlInt = REGISTRATION_URL_INT
    complianceUrlInt = COMPLIANCE_URL_INT
    limitUrlInt = LIMIT_URL_INT
    fxIntegratorUrlInt = FX_INTEGRATOR_URL_INT
    registrationUrlExt = REGISTRATION_URL_EXT
    complianceUrlExt = COMPLIANCE_URL_EXT
    limitUrlExt = LIMIT_URL_EXT
    callbackURL = CALLBACK_URL
    authURL = AUTH_URL

    # PARTNERS IDS #
    BexsBanco = "cd7a5cdc-5a8e-42ad-91c5-450558521538"
    Nubank = "67ca469e-143f-4867-b182-4ac9bdc4f111"
    Nubank2 = "8c0c4081-b437-41c2-b21b-10490b018f41"
    Revolut = "a2872d3d-43ae-4168-af75-7ffcb45a3192"
    OpenSolo = "71ad17a5-17f9-43d3-93ba-32344a660bba"
    B2W = "4952dcfbc50c4328b8bdd35bb22946c9"
    Pay = "3ca9371316cf430b829c5dd3e91c811b"
    Ebanx = "e205962aa8614fe9bdabce98b8e2db29"
    Susnstate = "b776686d-4584-4a98-a0e1-cf84567f12c1"
    Vixtra = "19e51617-b134-4dc5-b800-023ae8c673cc"
    Sunstate = "b776686d-4584-4a98-a0e1-cf84567f12c1"
    Dlocal = "99901b8e-9e41-43a2-b79a-f4d167d22ff1"
    PPRO = "4ba17c37-6dba-4330-8e4d-c1219fab7437"
    Jeeves = "34f7d05e-4709-4c1d-80ff-fc7cc1dcf72d"
    BoaCompra = "e87b6ff8-8b08-49b7-a922-379b02a975ef"
    BlacklistPartner = "e87b6ff8-8b08-49b7-a922-379b02a975ef"
    Keeta = "52a36ee0-0984-4f00-8f5d-2ec06d302a13"
    WatchlistPartner = "cd7a5cdc-5a8e-42ad-91c5-450558521599"

    # offertype#
    DigitalTransfInvest = "DIGITAL_FX_TRANSF_AND_INVEST"
    MaquininhaAPI = "MAQUININHA_API_01"
    MaquininhaCripto = "MAQUININHA_CRIPTO"
    MaquininhaPortal = "MAQUININHA_01"
    WebpaymentMarketplace = "WEB_PAYMENT_MARKETPLACE"
    PayMyTuition = "BEXS_PAY_2"
    Blacklist = "TESTE_BLACKLIST_RULE"
    Watchlist = "TEST_WATCHLIST_RULE"

    # aux funcs
    process_tas_files = process_tas_files
    mock_tas_files = mock_tas_files
    get_bureau_individual = get_bureau_individual
    get_bureau_company = get_bureau_company
