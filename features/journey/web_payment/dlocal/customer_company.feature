@functional
Feature: Journey Web Payment Marketplace Company Profile - Dlocal


    Scenario: Should approve profile when it meets all the requirements
        Given mock bureau "cnpj-regular"
        Given create customer PJ with partner "Dlocal", offer "WebpaymentMarketplace"
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent

    Scenario: should approved profile with registration status other than removed
        Given mock bureau "cnpj-removed"
        Given create customer PJ with partner "Dlocal", offer "WebpaymentMarketplace"
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent

    Scenario: should profile rejected with registration status equal to not found
        Given mock bureau "cnpj-not-found"
        Given create customer PJ with partner "Dlocal", offer "WebpaymentMarketplace"
        Then I check the "REJECTED" compliance status
        Then I check the "REJECTED" status of the onboarding status
        Then check that the callback was sent

