Feature: Satisfaction
  As a Pension Wise data analyst
  I want to know customer satisfaction
  So that I can understand whether then service is performing to the required standard

  Scenario: Viewing satisfaction summary
    Given I am logged in as a Pension Wise data analyst
    And there are existing satisfaction records
    When I visit the satisfaction report
    Then I see the satisfaction summary report
    And the date range is displayed

  Scenario: Downloading the summary data
    Given I am logged in as a Pension Wise data analyst
    And there are existing satisfaction records
    When I visit the satisfaction report
    And I export the summary data to CSV
    Then I am prompted to download the "satisfaction_data" CSV

  Scenario: Downloading the raw data
    Given I am logged in as a Pension Wise data analyst
    And there are existing satisfaction records
    When I visit the satisfaction report
    And I export the raw data to CSV
    Then I am prompted to download the "satisfaction_data_raw" CSV
