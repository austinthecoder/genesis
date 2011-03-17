Feature: Template Fields

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user
    And I have a "Home" template
    And I have a "body" field for that template
    When I follow "edit" within the row for the "body" field

  Scenario: Basic
    When I fill in "Name" with "something"
    And I press "Save"
    Then I should see "something" within the fields table
    Then I should not see "body" within the fields table

##################################################

  Scenario: Pre-populating fields
    Then the "Name" field should contain "body"

##################################################

  Scenario: Validations
    When I fill in "Name" with ""
    And I press "Save"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input