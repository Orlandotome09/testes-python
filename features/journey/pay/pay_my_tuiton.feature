@functional
Feature: PAY MY TUITION JOURNEY

    Scenario: Should approve profile when it meets all the requirements
        Given create Merchant PJ with partner "Pay", offer "PayMyTuition"
        Then I check the "APPROVED" compliance status
        Given an individual customer PF with partner "Pay", offer "PayMyTuition", income 1000, parent_id and without name and email
        When check for missing EMAIL_REQUIRED , LAST_NAME_REQUIRED and DOCUMENT_NOT_FOUND_IDENTIFICATION
        When add the document with subtype "IDENTIFICATION", sub type "RG", number "123" and name "Testqa"
        When add the file
        When upadate in email and last name
        When check approved
        When add the document "INVOICE", number "123" and name "testeqa"
        When add the file
        When create contract for invoice
        Then I check the "APPROVED" status of the onboarding status
