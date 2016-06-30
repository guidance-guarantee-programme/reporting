Feature: Manual appointment summary data
  As a Pension Wise data analyst
  I want to be able to manually input appointment summary data
  So to generate reports when the source data can not be automatically imported

  Scenario: I can manually create an appointment summary record
    Given I am logged in as a Pension Wise data analyst
    When I create a new appointment summary record
    Then the appointment summary record is successfully saved

  Scenario: I can override a automatically generated appointment summary record
    Given I am logged in as a Pension Wise data analyst
    And an existing automatically generated appointment summary record exists
    When I edit the appointment summary record
    Then my changes are saved and the record is marked as a manually generated appointment summary record

  Scenario: I require edit permission to access edit manual appointment summary records
    Given I am logged in as a Pension Wise user
    When I attempt to create a new appointment summary record
    Then I am redirected away with the notice "You do not have the required permissions"
