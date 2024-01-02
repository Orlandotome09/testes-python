from functools import partial
from pytest_bdd import scenarios, given, then, when, parsers
from support import utils
from support.config import Config
import time,base64, random, datetime

scenarios("../features/bureau_tas/enrich_individual_cache_with_tas.feature")

EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)

@given(
    parsers.cfparse("Generate Document"),
    target_fixture="documentNumber",
)
def generate_DOC():
    documentNumber = utils.generate_cpf()
    return documentNumber

@given(
    parsers.cfparse("Not Exist in cache"),
    target_fixture="cache",
)
def get_bureau_individual(documentNumber):

    response = Config.get_bureau_individual(documentNumber)

    assert response.status_code == 204

@given(
    parsers.cfparse('mock Date and encoded file cpf "{statusBureau}"'),
    target_fixture="random_date",
)
def mock_file(documentNumber, statusBureau):
    message = convertStatusBureauToMessage(documentNumber, statusBureau)

    message_bytes = message.encode("ascii")
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode("ascii")

    # cria data aleatoria
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
def process_file(random_date):
    d2 = random_date.strftime("%Y%m%d")

    response = Config.process_tas_files("CPF", d2)
    assert response.status_code == 201

    return response


@then(
    parsers.cfparse(
        'Exist in cache an individual with provider TAS in status "{status}"'
    ),
    target_fixture="cache",
)
def get_bureau_individual(documentNumber, status):
    time.sleep(10)

    response = Config.get_bureau_individual(documentNumber)
    responseJson = response.json()

    assert responseJson["cadastral_situation"]["value"]["situation"] == status
    assert responseJson["personal_id"]["value"] == documentNumber
    assert responseJson["provider"] == "TAS"


@given(
    parsers.cfparse(
        "Includes new status for a CPF already in the cache, but with an earlier date than it is in the cache"
    ),
    target_fixture="random_date",
)
def mock_file(documentNumber):
    message = (
        """020210102001
    12"""
        + documentNumber
        + """      
    200000001999"""
    )

    message_bytes = message.encode("ascii")
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode("ascii")

    # cria data aleatoria
    start = datetime.date(1970, 1, 1)
    end = datetime.date(1979, 1, 1)

    random_date = start + (end - start) * random.random()
    d1 = random_date.strftime("%d%m%Y")

    response = Config.mock_tas_files(d1, base64_message)
    assert response.status_code == 201

    return random_date

@given(
    parsers.cfparse("mock new Date and encoded new file with cpf SUSPENSA"),
    target_fixture="random_date",
)
def mock_new_file(documentNumber):
    message = (
        """020210102001
    12"""
        + documentNumber
        + """      
    200000001999"""
    )

    message_bytes = message.encode("ascii")
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode("ascii")

    # cria data aleatoria
    start = datetime.date(3000, 1, 1)
    end = datetime.date(4000, 1, 1)

    random_date = start + (end - start) * random.random()
    d1 = random_date.strftime("%d%m%Y")

    response = Config.mock_tas_files(d1, base64_message)
    assert response.status_code == 201

    return random_date


def convertStatusBureauToMessage(documentNumber, statusBureau):
    if statusBureau == "REGULAR":
        return (
        """020210102001
    10"""

        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "SUSPENSA":
        return (
        """020210102001
    12"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "TITULAR FALECIDO":
        return (
        """020210102001
    13"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "PENDENTE DE REGULARIZACAO":
        return (
        """020210102001
    14"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "CANCELADA POR MULTIPLICIDADE":
        return (
        """020210102001
    15"""
        + documentNumber
        + """      
    200000001999"""
    )
    elif statusBureau == "NULA":
        return (
        """020210102001
    18"""
        + documentNumber
        + """      
    200000001999"""
    ) 
    elif statusBureau == "CANCELADA DE OFICIO":
        return (
        """020210102001
    19"""
        + documentNumber
        + """      
    200000001999"""
    )    

    return ""