import requests
import json
from pathlib import Path


class RestService:
    def __init__(self):
        self.__response = None
        self.__status_code = None
