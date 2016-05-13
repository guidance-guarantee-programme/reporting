Feature: Where did you hear about us?
  As a Pension Wise data analyst
  I want to know how people hear about us
  So that I can understand whether demand for the service has changed

  Scenario: Viewing where did you hear about us records
    Given I am logged in as a Pension Wise data analyst
    And there are existing where did you hear about us records
    When I visit the where did you hear about us report
    Then I am presented with where did you hear about us records
    And I see there are multiple pages
    And the date range is displayed

  Scenario: Viewing where did you hear about us records
    Given I am logged in as a Pension Wise data analyst
    And there are existing where did you hear about us records
    When I visit the where did you hear about us report
    And I export the results to CSV
    Then I am prompted to download the CSV

  Scenario: Viewing the summary report
    Given I am logged in as a Pension Wise data analyst
    And there are existing where did you hear about us records
    When I visit the where did you hear about us report
    And I request the summary report
    Then I see the summary report
