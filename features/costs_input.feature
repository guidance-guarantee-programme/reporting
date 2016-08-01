Feature: Costs Input
  I want to be able to input cost data
  So that it is available for reporting

  Scenario: Creating costs for a month
    When I input the costs for the month
    Then I should be able to the monthly costs
