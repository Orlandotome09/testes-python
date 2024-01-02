@functional
Feature: Journey Web Payment Marketplace Company Profile


    Scenario: Should leave profile supplier as analysing when it is not manually approved
        Given mock bureau "cnpj-regular"
        When create supplier PJ with partner "B2W", offer "WebpaymentMarketplace"
        Then I check the "ANALYSING" compliance status
        Then I check the "ANALYSING" status of the onboarding status

    Scenario: Should approve profile supplier when it meets all the requirements
        Given mock bureau "cnpj-regular"
        When create supplier PJ with partner "B2W", offer "WebpaymentMarketplace"
        And  is manually approved
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status

    Scenario: Document was not found in the bureau
        Given mock bureau "cnpj-not-found"
        When create supplier PJ with partner "B2W", offer "WebpaymentMarketplace"
        Then I check the "REJECTED" compliance status
        Then I check the "REJECTED" status of the onboarding status