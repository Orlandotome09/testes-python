

@functional
Feature: Journey Maquininha API Nubank Counterparty Company


    Scenario: should approve counterparty
        Given create counterparty PJ
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status



