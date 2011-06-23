Feature: Removing pages

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user
    And I have a template

##################################################

  Scenario: Basic removal
    Given I have a "Home" page

    When I visit the pages page
    And I press "remove" within the row for that page
    Then I should see "Page was removed."
    And I should not see "Home" within the list of pages

##################################################

  Scenario: Can only remove pages without children
    Given I have a "Home" page
    And I have an "About" page for that page
    And I have an "Our Company" page for that page
    And I have a "Contact" page for the "Home" page

    When I visit the pages page
    Then I should not see the "remove" button within the row for the "Home" page
    And I should not see the "remove" button within the row for the "About" page
    And I should see the "remove" button within the row for the "Our Company" page
    And I should see the "remove" button within the row for the "Contact" page

##################################################

  Scenario: Restoring after removal
    Given I have a "Home" page

    When I remove the "Home" page
    And I press "Undo"
    Then I should see "Page was added back."
    And I should see "Home" within the list of pages