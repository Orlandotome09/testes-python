@regression
Feature: Blacklist Rule

    Background: Create partner, offer and catalogs
        Given create partner
        Given create offer
        Given create catalog blacklist PF
        Given create catalog blacklist PJ



    Scenario: Should Profile individual present in a Blacklist
        Given document present in internal list with fuill name "Test Blacklist PF" and person type "INDIVIDUAL"
        Given an individual customer PF with mock and partner "BlacklistPartner", offer "Blacklist", income 1000
        Then I check the "ANALYSING" compliance status
        Then I check the "ANALYSING" compliance status black list


    Scenario: Should Profile company present in a Blacklist
        Given document present in internal list with fuill name "Test Blacklist PJ" and person type "COMPANY"
        Given create customer PJ with partner "BlacklistPartner", offer "Blacklist"
        Then I check the "ANALYSING" compliance status
        Then I check the "ANALYSING" compliance status black list