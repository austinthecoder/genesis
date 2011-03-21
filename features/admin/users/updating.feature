Feature: Updating Info

  Background:
    Given a site
    And a user for that site with the attributes:
      | Name  | Jeff Johnson   |
      | Email | jj@example.com |
    And I am signed in as that user

  Scenario: Pre-populated fields
    When I follow "Jeff Johnson"
    Then the "Name" field should be "Jeff Johnson"
    And the "Email" field should be "jj@example.com"

##################################################

  @wip
  Scenario: Performing update
    When I