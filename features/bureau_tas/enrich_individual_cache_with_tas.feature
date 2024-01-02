@regression
Feature: Enrich individual cache with TAS
    
    Scenario Outline: should enrich individual cache with tas file information
        Given Generate Document
        Given Not Exist in cache
        Given mock Date and encoded file cpf "<status_bureau>"
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "<status_bureau>"

        Examples:
        | status_bureau                 | 
        | REGULAR                       |
        | SUSPENSA                      |
        | TITULAR FALECIDO              |
        | PENDENTE DE REGULARIZACAO     |
        | CANCELADA POR MULTIPLICIDADE  |
        | NULA                          |
        | CANCELADA DE OFICIO           |

    Scenario: If it exists in the cache, and what arrives from the file has a lower date, then it does not update
        #include in cache
        Given Generate Document
        Given mock Date and encoded file cpf "REGULAR"
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "REGULAR"
        #does not update, because date is smaller than the current one
        Given Includes new status for a CPF already in the cache, but with an earlier date than it is in the cache
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "REGULAR"

    Scenario: If it exists in the cache with a status other than CANCELED and DECEASED, and what arrives in the file has a higher date, then it updates
        #include in cache
        Given Generate Document
        Given mock Date and encoded file cpf "REGULAR"
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "REGULAR"
        #include new date with new status
        Given mock new Date and encoded new file with cpf SUSPENSA
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "SUSPENSA"

    Scenario: If it exists in the cache with status CANCELADA DE OFICIO, and what arrives in the file has a higher date, then it does not update
        #include in cache
        Given Generate Document
        Given mock Date and encoded file cpf "CANCELADA DE OFICIO"
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "CANCELADA DE OFICIO"
        #include new date with new status
        Given mock new Date and encoded new file with cpf SUSPENSA
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "CANCELADA DE OFICIO"

    Scenario: If it exists in the cache with status TITULAR FALECIDO, and what arrives in the file has a higher date, then it does not update
        #include in cache
        Given Generate Document
        Given mock Date and encoded file cpf "TITULAR FALECIDO"
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "TITULAR FALECIDO"
        #include new date with new status
        Given mock new Date and encoded new file with cpf SUSPENSA
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "TITULAR FALECIDO"

    Scenario: If it exists in the cache with status CANCELADA POR MULTIPLICIDADE, and what arrives in the file has a higher date, then it does not update
        #include in cache
        Given Generate Document
        Given mock Date and encoded file cpf "CANCELADA POR MULTIPLICIDADE"
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "CANCELADA POR MULTIPLICIDADE"
        #include new date with new status
        Given mock new Date and encoded new file with cpf SUSPENSA
        When the date is processed
        Then Exist in cache an individual with provider TAS in status "CANCELADA POR MULTIPLICIDADE"