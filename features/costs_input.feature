Feature: Costs Input
  As a Finance guy
  I want to be able to input cost data
  So that it is available for reporting

  Scenario: Creating costs for a month
    Given cost items exist
    When I set costs for the month
    Then costs for the month have been saved

  Scenario: Updating costs for a month
    Given cost items exist
    And existing costs exist for the month
    When I update costs for the month
    Then cost deltas for the month have been saved
