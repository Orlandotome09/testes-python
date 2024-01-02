@functional
Feature: Journey Web Payment Marketplace Company Profile


    Scenario: Should approve profile when it meets all the requirements
        Given mock bureau "cnpj-regular"
        Given create customer PJ with partner "B2W", offer "WebpaymentMarketplace"
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status