@functional
Feature: Counterparty Global

    Scenario: Should approve profile counterparty PF when it meets all the requirements - Global
        When creates profile INDIVIDUAL with role type COUNTERPARTY offer DIGITAL_FX_TRANSF_AND_INVEST and partner 34f7d05e-4709-4c1d-80ff-fc7cc1dcf72d
        Then I verify that the profile is approved in compliance

    Scenario: Should approve profile counterparty PJ when it meets all the requirements - Global
        When creates profile COMPANY with role type COUNTERPARTY offer DIGITAL_FX_TRANSF_AND_INVEST and partner 34f7d05e-4709-4c1d-80ff-fc7cc1dcf72d
        Then I verify that the profile is approved in compliance
