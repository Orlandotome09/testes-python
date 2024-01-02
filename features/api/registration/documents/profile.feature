@regression
Feature: Document shareholder

  Scenario Outline: Should Create all types document for shareholder
    Given a PJ profile
    When create a profile document of the type "<type>"
    Then then I see the document created "<expected>"

    Examples:
      | type                                    | expected                                |
      | KYC                                     | KYC                                     |
      | IDENTIFICATION                          | IDENTIFICATION                          |
      | BUREAU_PROOF_OF_ADDRESS                 | BUREAU_PROOF_OF_ADDRESS                 |
      | PROOF_OF_LIFE                           | PROOF_OF_LIFE                           |
      | INCOME_TAX_RECEIPT                      | INCOME_TAX_RECEIPT                      |
      | REGISTRATION_FORM                       | REGISTRATION_FORM                       |
      | PASSPORT                                | PASSPORT                                |
      | INVOICE                                 | INVOICE                                 |
      | ACCOUNT_OPENING_CONTRACT                | ACCOUNT_OPENING_CONTRACT                |
      | MANDATORY_STATEMENTS_AGREEMENT_EVIDENCE | MANDATORY_STATEMENTS_AGREEMENT_EVIDENCE |
      | CORPORATE_DOCUMENT                      | CORPORATE_DOCUMENT                      |
      | PROOF_OF_ADDRESS                        | PROOF_OF_ADDRESS                        |
      | SUPPLIER_AGREEMENT                      | SUPPLIER_AGREEMENT                      |
      | BUSINESS_LICENSE                        | BUSINESS_LICENSE                        |
      | FINANCIAL_STATEMENT                     | FINANCIAL_STATEMENT                     |
      | PROOF_OF_FINANCIAL_STANDING             | PROOF_OF_FINANCIAL_STANDING             |
      | APPOINTMENT_DOCUMENT                    | APPOINTMENT_DOCUMENT                    |
      | CONSTITUTION_DOCUMENT                   | CONSTITUTION_DOCUMENT                   |
      | PROOF_OF_SHAREHOLDER_CHAIN              | PROOF_OF_SHAREHOLDER_CHAIN              |
      | INCOME_TAX_DECLARATION                  | INCOME_TAX_DECLARATION                  |
      | CGD/DERIVATIVES                         | CGD/DERIVATIVES                         |
      | FWD/FUTURE_FOREIGN_EXCHANGE             | FWD/FUTURE_FOREIGN_EXCHANGE             |


  Scenario: Should Create document and file for shareholder
    Given a PJ profile
    When create a profile document of the type "BUREAU_PROOF_OF_ADDRESS"
    When add the file in profile
    Then then I see the document created "BUREAU_PROOF_OF_ADDRESS"
    Then then I see the documentFile created
    Then check documentfile in temis query