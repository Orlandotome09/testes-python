from functools import partial
from pytest_bdd import scenarios, given, then, when, parsers
from support import utils
from support.config import Config
import time, base64, random, datetime

scenarios("../features/bureau_tas/enrich_company_cache_with_tas.feature")

EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)

@given(
    parsers.cfparse("Generate Document"),
    target_fixture="documentNumber",
)
def generate_DOC():
    documentNumber = utils.generate_cnpj()
    return documentNumber

@given(
    parsers.cfparse("Not Exist in cache"),
    target_fixture="cache",
)
def get_bureau_ompany(documentNumber):

    response = Config.get_bureau_company(documentNumber)

    assert response.status_code == 204

@given(
    parsers.cfparse('mock Date and encoded file cnpj "{statusBureau}"'),
    target_fixture="random_date",
)
def mock_date(documentNumber, statusBureau):
    message = convertStatusBureauToMessage(documentNumber, statusBureau)

    message_bytes = message.encode("ascii")
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode("ascii")

    start = datetime.date(1980, 1, 1)
    end = datetime.date(3000, 1, 1)
    random_date = start + (end - start) * random.random()
    d1 = random_date.strftime("%d%m%Y")

    response = Config.mock_tas_files(d1, base64_message)
    assert response.status_code == 201

    return random_date

@when(
    parsers.cfparse("the date is processed"),
    target_fixture="response",
)
def mock_date(random_date):
    d2 = random_date.strftime("%Y%m%d")

    response = Config.process_tas_files("CNPJ", d2)
    assert response.status_code == 201

    return response

@then(
    parsers.cfparse(
        'Exist in cache a company with provider TAS in status "{statusBureau}"'
    ),
    target_fixture="cache",
)
def get_bureau_company(documentNumber, statusBureau):
    time.sleep(10)

    response = Config.get_bureau_company(documentNumber)
    responseJson = response.json()

    assert responseJson["cadastral_situation"]["value"]["situation"] == statusBureau
    assert responseJson["company_id"]["value"] == documentNumber
    assert responseJson["provider"] == "TAS"

@given(
    parsers.cfparse(
        'Includes new status "{statusBureau}" for a CNPJ already in the cache, but with an earlier date than it is in the cache'
    ),
    target_fixture="random_date",
)
def mock_date(documentNumber, statusBureau):
    message = convertStatusBureauToMessage(documentNumber, statusBureau)

    message_bytes = message.encode("ascii")
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode("ascii")

    start = datetime.date(1970, 1, 1)
    end = datetime.date(1979, 1, 1)

    random_date = start + (end - start) * random.random()
    d1 = random_date.strftime("%d%m%Y")

    response = Config.mock_tas_files(d1, base64_message)
    assert response.status_code == 201

    return random_date

@given(
    parsers.cfparse(
        'Includes new status "{statusBureau}" for a CNPJ already in the cache, but with an higher date than it is in the cache'
    ),
    target_fixture="random_date",
)
def mock_date(documentNumber, statusBureau):
    message = convertStatusBureauToMessage(documentNumber, statusBureau)

    message_bytes = message.encode("ascii")
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode("ascii")

    start = datetime.date(4000, 1, 1)
    end = datetime.date(4001, 1, 1)

    random_date = start + (end - start) * random.random()
    d1 = random_date.strftime("%d%m%Y")

    response = Config.mock_tas_files(d1, base64_message)
    assert response.status_code == 201

    return random_date

def convertStatusBureauToMessage(documentNumber, statusBureau):
    if statusBureau == "NULA":
        return (
        """020210102001
    11"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "ATIVA":
        return (
        """020210102001
    12"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "SUSPENSA":
        return (
        """020210102001
    13"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "INAPTA":
        return (
        """020210102001
    14"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "BAIXADA":
        return (
        """020210102001
    18"""
        + documentNumber
        + """      
    200000001999"""
    )   

    return ""
        

    