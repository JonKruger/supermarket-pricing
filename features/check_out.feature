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


