@functional
Feature: Journey Web Payment Marketplace Company Profile - Boa compra


    Scenario: Should approve profile when is suspended on Bureau - boa compra
        Given mock bureau PF "cpf-suspended"
        Given an individual customer PF with mock and partner "BoaCompra", offer "WebpaymentMarketplace", income 1000
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent

    Scenario: Should approve profile when is regular on Bureau - boa compra
        Given an individual customer PF with partner "BoaCompra", offer "WebpaymentMarketplace", income 1000
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent
