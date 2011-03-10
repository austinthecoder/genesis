Feature: Creating Templates

  Background:
    Given a user
    And I am signed in as that user
    And I follow "Theme"

##################################################

  Scenario: Simple
    When I follow "Add a template"
    And I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"
    And I should see "Home" within the templates within the sidebar

##################################################

  Scenario: Making sure name isn't blank
    When I follow "Add a template"
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input within the template form

    When I fill in "Name" with "Home"
    And I press "Save this template"
    And I fill in "Name" with ""
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input within the template form

##################################################

  Scenario: Making sure name is unique per user
    Given another user
    And a template for the other user named "Home"

    When I follow "Add a template"
    And I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"

    When I follow:
      | Theme | Add a template |
    And I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "has already been taken" within the name input within the template form

##################################################

  Scenario: Continual editing
    When I follow "Add a template"
    And I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then the "Name" field should contain "Home"
    And the template's content field should contain "some content"

    When I follow "Home" within the templates within the sidebar
    Then the "Name" field should contain "Home"
    And the template's content field should contain "some content"

    When I fill in "Name" with "Home changed"
    And I fill in the template's content with "some content changed"
    And I press "Save this template"
    Then the "Name" field should contain "Home changed"
    And the template's content field should contain "some content changed"

    When I follow "Home" within the templates within the sidebar
    Then the "Name" field should contain "Home changed"
    And the template's content field should contain "some content changed"

##################################################

  Scenario: Removing
    Given I have a "Home" template

    # basic removal
    When I remove that template
    Then I should see "Template was removed"

    When I press "Undo"
    Then I should see "Template was added back."
    And I should see "Home" within the templates

    # ensuring fields are restored
    When I add a "body" field for that template
    And I add a "footer" field for that template
    And I remove that template
    And I press "Undo"
    And I visit the fields page for that template
    Then I should see "body" within the fields
    And I should see "footer" within the fields

