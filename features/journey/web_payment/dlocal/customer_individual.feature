@functional
Feature: Journey Web Payment Marketplace Company Profile - Dlocal



    Scenario: Should approve profile when it meets all the requirements test
        Given an individual customer PF with partner "Dlocal", offer "WebpaymentMarketplace", income 1000
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent


    Scenario: should approved profile with registration status other than canceled - - Dlocal
        Given mock bureau PF "cpf-canceled"
        Given an individual customer PF with mock and partner "Dlocal", offer "WebpaymentMarketplace", income 1000
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent


    Scenario: should approved profile with registration status other than deceased holder- - Dlocal
        Given mock bureau PF "cpf-holder-deceased"
        Given an individual customer PF with mock and partner "Dlocal", offer "WebpaymentMarketplace", income 1000
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent


    Scenario: should approved profile with registration status other than deceased holder- - Dlocal
        Given mock bureau PF "cpf-holder-deceased"
        Given an individual customer PF with mock and partner "Dlocal", offer "WebpaymentMarketplace", income 1000
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent


    Scenario: should approved profile with registration status other than suspended- - Dlocal
        Given mock bureau PF "cpf-suspended"
        Given an individual customer PF with mock and partner "Dlocal", offer "WebpaymentMarketplace", income 1000
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status
        Then check that the callback was sent


    Scenario: should profile rejected with registration status equal to not found - Dlocal
        Given mock bureau PF "cpf-not-found"
        Given an individual customer PF with mock and partner "Dlocal", offer "WebpaymentMarketplace", income 1000
        Then I check the "REJECTED" compliance status
        Then I check the "REJECTED" status of the onboarding status
        Then check that the callback was sent