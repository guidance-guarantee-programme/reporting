Feature: Calls via the website
  As a Pension Wise data analyst
  I want to know the call volumes for Citizens Advice and TPAS that have originated from the website
  So that I can understand and report on whether demand of the service is increasing, decreasing, or staying stable

  Scenario: Citizens Advice calls are correctly displayed
    Given I am logged in as a Pension Wise data analyst
    And there are existing daily call volumes for Twilio
    When I visit the call volume report
    And I enter a valid date range
    Then the total number of calls for Twilio within the date range is returned
    And a day-by-by breakdown for Twilio within the date range is returned

  Scenario: TPAS calls are correctly displayed
    Given I am logged in as a Pension Wise data analyst
    And there are existing daily call volumes for the contact centre
    When I visit the call volume report
    And I enter a valid date range
    Then the total number of calls for the contact centre within the date range is returned
    And a day-by-by breakdown for the contact centre within the date range is returned

  Scenario: export calls to csv
    Given I am logged in as a Pension Wise data analyst
    When I visit the call volume report
    And I enter a valid date range
    And I export the results to CSV
    Then I am prompted to download a CSV
