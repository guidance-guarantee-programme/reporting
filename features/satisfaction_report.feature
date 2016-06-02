Feature: Satisfaction
  As a Pension Wise data analyst
  I want to know customer satisfaction
  So that I can understand whether then servcie is performing to the required standard

  Scenario: Viewing satisfaction summary
    Given I am logged in as a Pension Wise data analyst
    And there are existing satisfaction records
    When I visit the satisfaction report
    Then I see the satisfaction summary report
    And the date range is displayed
