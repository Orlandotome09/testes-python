@regression
Feature: Enrich company cache with TAS

    Scenario Outline: should enrich company cache with tas file information
        Given Generate Document
        Given Not Exist in cache
        Given mock Date and encoded file cnpj "<status_bureau>"
        When the date is processed
        Then Exist in cache a company with provider TAS in status "<status_bureau>"

        Examples:
        | status_bureau | 
        | NULA          |
        | ATIVA         |
        | SUSPENSA      |
        | INAPTA        |
        | BAIXADA       |

    Scenario: If it exists in the cache, and what arrives from the file has a lower date, then it does not update
        #include in cache
        Given Generate Document
        Given mock Date and encoded file cnpj "ATIVA"
        When the date is processed
        Then Exist in cache a company with provider TAS in status "ATIVA"
        #does not update, because date is smaller than the current one
        Given Includes new status "SUSPENSA" for a CNPJ already in the cache, but with an earlier date than it is in the cache
        When the date is processed
        Then Exist in cache a company with provider TAS in status "ATIVA"
    
    Scenario: If it exists in the cache, and what arrives from the file has a higher date, then it does update
        #include in cache
        Given Generate Document
        Given mock Date and encoded file cnpj "ATIVA"
        When the date is processed
        Then Exist in cache a company with provider TAS in status "ATIVA"
        #does not update, because date is smaller than the current one
        Given Includes new status "SUSPENSA" for a CNPJ already in the cache, but with an higher date than it is in the cache
        When the date is processed
        Then Exist in cache a company with provider TAS in status "SUSPENSA"