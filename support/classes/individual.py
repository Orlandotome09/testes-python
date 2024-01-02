import json


class Phones:
    def __init__(self):
        self.type = "BUSINESS"
        self.number = "123"
        self.country_code = "55"
        self.area_code = "11"

    def to_json(self):
        return json.dumps(self, default=lambda o: o.__dict__)


class Individual:
    def __init__(self):
        self.first_name = "Test"
        self.last_name = "Digital"
        self.date_of_birth = "1991-07-30T00:00:00Z"
        self.income = None
        self.phones = Phones()

    def to_json(self):
        return json.dumps(self, default=lambda o: o.__dict__)


class Customer:
    def __init__(self):
        self.partner_id = None
        self.offer_type = None
        self.role_type = None
        self.profile_type = "INDIVIDUAL"
        self.document_number = None
        self.callback_url = None
        self.email = "teste@teste.com"
        self.individual = Individual()

    def to_json(self):
        return json.dumps(self, default=lambda o: o.__dict__)
