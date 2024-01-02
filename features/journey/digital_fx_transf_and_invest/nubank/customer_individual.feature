@functional
Feature: Customer Individual Nubank

  Scenario: Should approve profile when it meets all the requirements - Not create internal accounts- Nubank
    Given an individual customer PF with partner "NUBANK2", offer "DigitalTransfInvest", income 1000
    When check what is missing in the profile so that it is approved
    When add the address
    When add the document "IDENTIFICATION", number "123" and name "testeqa"
    When add the file
    When check approved
    Then I check the "APPROVED" compliance status
    Then check assigned limit 6000
    Then I check the assigned limit 6000 in Fx integrator
    Then I check the "APPROVED" status of the onboarding status
    Then check that the callback was sent


  Scenario: Should Analysing profile when the value of income is less than 1000 - Nubank
    Given an individual customer PF with partner "NUBANK2", offer "DigitalTransfInvest", income 999
    When check for missing ADDRESS_NOT_FOUND , DOCUMENT_NOT_FOUND_IDENTIFICATION and PERSON_HAS_INSUFFICIENT_INCOME
    When add the address
    When add the document "IDENTIFICATION", number "123" and name "testeqa"
    When add the file
    Then I check the "ANALYSING" compliance status
    Then I check the "ANALYSING" status of the onboarding status
