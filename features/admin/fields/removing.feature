Feature: Template Fields

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user
    And I have a "Home" template
    And I have a "body" field for that template

  Scenario: Removing
    When I press "remove" within the row for that field
    Then I should see "Field was removed."
    And I should not see "body" within the fields table

##################################################

  Scenario: Restoring
    When I press "remove" within the row for the "body" field
    And I press "Undo"
    Then I should see "Field was added back."
    And I should see "body" within the fields table

##################################################

  Scenario: Persisting content after restoring
    Given I have a "Home" page for that template

    When I fill in "Body" with "some content"
    And I press "Save"
    And I remove that field
    And I press "Undo"
    And I visit the page for that page
    Then the "Body" field should contain "some content"