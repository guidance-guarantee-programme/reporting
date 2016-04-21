Feature: Calls to Citizens Advice via the website
  As a data analyst
  I want to know the call volumes to Citizens Advice that have originated from the website
  So that I can understand and report on whether demand of the service is increasing, decreasing, or staying stable

  Scenario: retrieve number of calls
    Given I am logged in as a Pension Wise data analyst
    And there are existing Twilio daily call volumes
    When I visit the call volume report
    And I enter a valid date range
    Then the total number of successfully connected outbound Twilio calls within the date range are returned
    And a day-by-by breakdown within the date range is returned
