import requests
from functools import partial
from pytest_bdd import scenarios, given, then, when, parsers
from support import utils
from support import config
from support.config import Config
import json
import time

scenarios("../features/journey/maquininha/api/counterparty_individual.feature")

EXTRA_TYPES = {"Number": int, "Float": float}

parse_num = partial(parsers.cfparse, extra_types=EXTRA_TYPES)
