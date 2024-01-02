import json


def company_payload(company, addresses, accounts):
    request = {
        # "contact": {
        #     "document_number": company.contact.document_number,
        #     "email": company.contact.email,
        #     "full_name": company.contact.full_name,
        #     "nationality": company.contact.nationality,
        #     "phone": company.contact.phone
        # },
        "document_number": company.document_number,
        "legal_name": company.legal_name,
        "net_worth": company.net_worth,
        "gross_income": company.gross_income,
        "addresses": [
            {
                "city": addresses[0].city,
                "complement": addresses[0].complement,
                "country": addresses[0].country,
                "neighborhood": addresses[0].neighborhood,
                "number": addresses[0].number,
                "state": addresses[0].state,
                "street": addresses[0].street,
                "zip_code": addresses[0].zip_code
            },
            {
                "city": addresses[1].city,
                "complement": addresses[1].complement,
                "country": addresses[1].country,
                "neighborhood": addresses[1].neighborhood,
                "number": addresses[1].number,
                "state": addresses[1].state,
                "street": addresses[1].street,
                "zip_code": addresses[1].zip_code
            }
        ],
        "bank_accounts": [
            {
                "account_digit": accounts[0].account_digit,
                "account_number": accounts[0].account_number,
                "agency_digit": accounts[0].agency_digit,
                "agency_number": accounts[0].agency_number,
                "bank_code": accounts[0].bank_code
            },
            {
                "account_digit": accounts[1].account_digit,
                "account_number": accounts[1].account_number,
                "agency_digit": accounts[1].agency_digit,
                "agency_number": accounts[1].agency_number,
                "bank_code": accounts[1].bank_code
            }
        ]
    }

    request = json.dumps(request)
    return request
