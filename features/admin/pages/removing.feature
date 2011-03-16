Feature: Removing pages

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user

  Scenario: Basic removal
    Given I have a "Home" page

    When I visit the pages page
    And I press "remove" within the row for that page
    Then I should see "Page was removed."
    And I should not see "Home" within the list of pages

##################################################

  Scenario: Subtree removal
    Given I have a "Home" page
    And I have an "About" page for that page
    And I have an "Our Company" page for that page
    And I have a "Contact" page for the "Home" page

    When I remove the "Home" page
    Then I should not see each of the following within the list of pages:
      | Home | About | Our Company | Contact |

##################################################

  Scenario: Restoring after removal
    Given I have a "Home" page

    When I remove the "Home" page
    And I press "Undo"
    Then I should see "Page was added back."
    And I should see "Home" within the list of pages

##################################################

  Scenario: Restoring subtree after removal
    Given I have a "Home" page
    And I have an "About" page for that page
    And I have an "Our Company" page for that page
    And I have a "Contact" page for the "Home" page

    When I remove the "Home" page
    And I press "Undo"
    Then I should see each of the following within the list of pages:
      | Home | About | Our Company | Contact |