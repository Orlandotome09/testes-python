
@functional
Feature: Journey Maquininha API Nubank Counterparty Individual


    Scenario: should approve counterparty
        Given create counterparty PF
        Then I check the "APPROVED" compliance status
        Then I check the "APPROVED" status of the onboarding status



