@regression
Feature: Customer Individual Keeta

  Scenario: Should approve profile when it meets all the requirements - Keeta
    Given an individual customer PF with partner "Keeta", offer "DigitalTransfInvest", income 10000
    When check what is missing in the profile so that it is approved
    When add the address
    When add the document "IDENTIFICATION", number "123" and name "testeqa"
    When add the file
    When check approved
    Then I check the assigned limit 120000 in Fx integrator
    When add the document "INCOME_TAX_DECLARATION", number "123" and name "testeqa"
    When add the file
    Then I check eligibility for custom limit
    When I assign the custom limit
    Then I check if the eligibility flag is False
    Then I check the assigned custom limit
    Then I check the assigned limit 200000 in Fx integrator
    Then I check the "APPROVED" status of the onboarding status
    Then Limit 200000 assignment in temis query
    Then check that the callback was sent