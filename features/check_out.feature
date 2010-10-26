Feature: Checkout

  Scenario Outline:
    Given that I have not checked anything out
    When I check out item <item>
    Then the total price should be the <unit price> of that item

  Examples:
    | item | unit price |
    | "A"  | 50         |
    | "B"  | 30         |
    | "C"  | 20         |
    | "D"  | 15         |

  Scenario Outline:
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
    | "BABBAA"       | 175                  | order doesn't matter |
    | ""             | 0                    |                      |
