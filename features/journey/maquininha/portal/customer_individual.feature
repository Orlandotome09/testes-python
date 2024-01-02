@functional
Feature: Journey Maquinininha Portal Customer Individual


  Scenario: Should approve profile when it meets all the requirements
    Given an individual customer PF with partner "BexsBanco", offer "MaquininhaPortal", income 1000
    When add the address
    When add the document "IDENTIFICATION", number "123" and name "testeqa"
    When add the file
    When add the document "PROOF_OF_ADDRESS", number "123" and name "testeqa"
    When add the file
    When check approved
    Then I check the "APPROVED" compliance status
    Then I check the "APPROVED" status of the onboarding status
    Then check that the callback was sent

  Scenario: Created profile is not approved since it is INCOMPLETE
    Given an individual customer PF with partner "BexsBanco", offer "MaquininhaPortal", income 1000
    When check for missing ADDRESS_NOT_FOUND , DOCUMENT_NOT_FOUND_IDENTIFICATION and DOCUMENT_NOT_FOUND_PROOF_OF_ADDRESS
    Then I check the "INCOMPLETE" compliance status
    Then I check the "INCOMPLETE" status of the onboarding status