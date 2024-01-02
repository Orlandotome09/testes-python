@regression
Feature: Watchlist Rule

    Background: Create partner, offer and catalogs
        Given create partner Watchlist
        Given create offer Watchlist
        Given create config Watchlist PF
        Given create config Watchlist PJ


    Scenario: Should Profile individual present in a Watchlist
        Given document present in Watchlist PF
        Given an individual customer PF with mock and partner "WatchlistPartner", offer "Watchlist", income 1000
        Then I check the "ANALYSING" compliance status
        Then I check the "ANALYSING" compliance status Watchlist


    Scenario: Should Profile company present in a Watchlist
        Given document present in Watchlist PJ
        Given create customer PJ with partner "WatchlistPartner", offer "Watchlist" and legal name "SomeCompanyNamePresent"
        Then I check the "ANALYSING" compliance status
        Then I check the "ANALYSING" compliance status Watchlist