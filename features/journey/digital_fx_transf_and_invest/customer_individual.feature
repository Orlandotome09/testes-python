@functional
Feature: Customer Individual Global

    Scenario: Should approve profile when it meets all the requirements - Global
        Given an individual customer PF with partner "Susnstate", offer "DigitalTransfInvest", income 1000
        When check what is missing in the profile so that it is approved
        When add the address
        When add the document "IDENTIFICATION", number "123" and name "testeqa"
        When add the file
        When check approved
        Then check assigned limit 6000
        Then I check the assigned limit 6000 in Fx integrator
        When add the document "PROOF_OF_ADDRESS", number "123" and name "testeqa"
        When add the file
        When add the document "INCOME_TAX_DECLARATION", number "123" and name "testeqa"
        When add the file
        Then I check the "APPROVED" compliance status
        Then validated the creation of the internal account
        Then check assigned limit 120000
        Then I check the assigned limit 120000 in Fx integrator
        Then I check eligibility for custom limit
        When I assign the custom limit
        Then I check if the eligibility flag is False
        Then I check the assigned custom limit
        Then I check the assigned limit 200000 in Fx integrator
        Then I check the "APPROVED" status of the onboarding status
        Then Limit 200000 assignment in temis query
        Then check that the callback was sent


    Scenario: Should not approve profile when framed in rule minimum income - Global
        Given an individual customer PF with partner "Susnstate", offer "DigitalTransfInvest", income 999
        When check for missing ADDRESS_NOT_FOUND , DOCUMENT_NOT_FOUND_IDENTIFICATION and PERSON_HAS_INSUFFICIENT_INCOME
        When add the address
        When add the document "IDENTIFICATION", number "123" and name "testeqa"
        When add the file
        Then I check the "ANALYSING" compliance status
        Then I check the "ANALYSING" status of the onboarding status


