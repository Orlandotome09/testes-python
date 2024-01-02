Feature: Complement of nature

  @functional @create
  Scenario Outline: Should Create profile Customer Individual with Complement of nature
    Given an individual customer PF with partner "Revolut", offer "DigitalTransfInvest", income 10 and complement of nature "<complementNature>"
    Then I receive a "201" status code
    Then I check the bacen_classification_type in temis query "<complementNature>"

    Examples:
      | complementNature |I check the bacen_classification_type in temis query
      | 02               |

  @functional @create
  Scenario Outline: Should Create profile Counter Party Company with Complement of nature
    Given create counterparty PJ with complement of nature "<complementNature>"
    Then I receive a "201" status code
    Then I check the bacen_classification_type in temis query "<complementNature>"

    Examples:
      | complementNature |
      | 05               |
      | 53               |
      | 56               |
      | 58               |
      | 59               |
      | 60               |
      | 66               |
      | 71               |
      | 73               |
      | 74               |
      | 75               |
      | 76               |
      | 77               |
      | 83               |
      | 88               |
      | 90               |

  @functional @create
  Scenario Outline: Should Create profile Counter Party Individual with Complement of nature
    Given create counterparty PF with complement of nature "<complementNature>"
    Then I receive a "201" status code
    Then I check the bacen_classification_type in temis query "<complementNature>"

    Examples:
      | complementNature |
      | 00               |
      | 02               |

  @functional @create
  Scenario Outline: Should Create profile Customer Company with Complement of nature
    Given create customer PJ with partner "NUBANK2", offer "DigitalTransfInvest" and complement of nature "<complementNature>"
    Then I receive a "201" status code
    Then I check the bacen_classification_type in temis query "<complementNature>"

    Examples:
      | complementNature |
      | 08               |
      | 09               |
      | 52               |
      | 55               |
      | 56               |
      | 58               |
      | 59               |
      | 66               |
      | 71               |
      | 78               |
      | 81               |
      | 84               |
      | 87               |

  @functional @create
  Scenario: Should Create profile Counter Party Individual with Complement of nature invalid
    Given create counterparty PF with complement of nature "52"
    Then I receive a "400" status code

  @functional @create
  Scenario: Should Create profile role type e person type not allowed for Complement of nature invalid
    Given create Merchant PJ with complement of nature "52"
    Then I receive a "201" status code

  @functional @PATCH
  Scenario: Should PATCH Complement of nature
    Given create customer PJ with partner "NUBANK2", offer "DigitalTransfInvest" and complement of nature "08"
    Then I receive a "201" status code
    Then I check the bacen_classification_type in temis query "08"
    When patch in complement of nature "52"
    Then I check the bacen_classification_type in temis query "52"

  @functional @UPDATE
  Scenario: Should PATCH Complement of nature
    Given create customer PJ with partner "NUBANK2", offer "DigitalTransfInvest" and complement of nature "08"
    Then I receive a "201" status code
    Then I check the bacen_classification_type in temis query "08"
    When UPDATE complement of nature "52"
    Then I check the bacen_classification_type in temis query "52"


