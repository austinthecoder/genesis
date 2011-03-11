Feature: Removing Templates

  Background:
    Given a user
    And I am signed in as that user
    And I have a "Home" template:
      """
      some template content
      """

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

  Scenario: After removing, template-related page fields are gone
    Given I have a "body" field for that template
    And I have a "Home" page for that template

    When I remove that template
    And I visit the page for that page
    Then I should not see the fields:
      | Template | Body |

##################################################

  Scenario: After restoring, template-related page fields are restored
    Given I have a "body" field for that template
    And I have a "Home" page for that template

    When I visit the page for that page
    And I fill in "Body" with "some content"
    And I press "Save"
    And I remove that template
    And I press "Undo"
    And I visit the page for that page
    Then I should see "Template Home"
    And the "Body" field should contain "some content"