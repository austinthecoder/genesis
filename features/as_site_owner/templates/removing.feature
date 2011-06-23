Feature: Removing Templates

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user
    And I have a "Home" template:
      """
      some template content
      """

##################################################

  Scenario: Removing it from the list
    When I remove that template
    Then I should see "Template was removed"
    And should not see "Home" within the templates

##################################################

  Scenario: Restoring
    When I remove that template
    And I press "Undo"
    Then I should see "Template was added back."
    And I should see "Home" within the templates

    When I visit the page for that template
    Then the "Name" field should contain "Home"
    And the template's content field should contain "some template content"

##################################################

  Scenario: Fields remain after restoring
    Given I have a "body" field for that template

    When I remove that template
    And I press "Undo"
    And I visit the fields page for that template
    Then I should see "body" within the fields

##################################################

  Scenario: Can't remove templates with pages
    Given I have a "Home" page for that template

    When I follow "Theme"
    Then I should not see "remove" within the row for that template