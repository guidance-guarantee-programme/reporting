Feature: Manual Upload of CITA appointments CSV
  As a Pension Wise data analyst
  I want to manually upload the CITA appointments CSV
  So that CITA appointments can be reported on

  Scenario: I can upload the appointments data
    Given I am logged in as a Pension Wise data analyst
    When I upload the cita.csv file for processing
    Then I can see the data file scheduled for processing

  Scenario Outline: I upload an invalid file
    Given I am logged in as a Pension Wise data analyst
    When I upload the <filename> file for processing
    Then I get an error
    And the data file is not scheduled for processing

    Examples:
      | filename          |
      | excel.xls         |
      | wrong_headers.csv |
      | binary.csv        |

  Scenario: Editing appointment summary records requires the correct permission
    Given I am logged in as a Pension Wise user
    When I attempt to upload the CITA appointments CSV
    Then I am redirected away with the notice "You do not have the required permissions"
