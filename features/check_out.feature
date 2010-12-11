Feature: Checkout

  Scenario Outline: Checking out individual items
    Given that I have not checked anything out
    When I check out item <item>
    Then the total price should be the <unit price> of that item

  Examples:
    | item | unit price |
    | "A"  | 50         |
    | "B"  | 30         |
    | "C"  | 20         |
    | "D"  | 15         |

  Scenario Outline: Checking out multiple items
    Given that I have not checked anything out
    When I check out <multiple items>
    Then the total price should be the <expected total price> of those items

  Examples:
    | multiple items | expected total price | notes                |
    | "AAA"          | 130                  | 3 for 130            |
    | "BB"           | 45                   | 2 for 45             |
    | "CCC"          | 60                   |                      |
    | "DDD"          | 45                   |                      |
    | "BBB"          | 75                   | (2 for 45) + 30      |
    | "BABBAA"       | 205                  | order doesn't matter |
    | ""             | 0                    |                      |

  Scenario Outline: Rounding money
    When rounding "<amount>" to the nearest penny
    Then it should round it using midpoint rounding to "<rounded amount>"

    Examples:
      | amount | rounded amount |
      | 1      | 1              |
      | 1.225  | 1.23           |
      | 1.2251 | 1.23           |
      | 1.2249 | 1.22           |
      | 1.22   | 1.22           |
