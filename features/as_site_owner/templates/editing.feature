Feature: Creating Templates

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user

##################################################

  Scenario: Simple
    When I visit the new template page
    And I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"
    And I should see "Home" within the templates within the sidebar

##################################################

  Scenario: Validations
    Given I have a "Home" template

    When I visit the new template page
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input within the template form

    When I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "has already been taken" within the name input within the template form

    When I fill in "Name" with "Blog"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"

##################################################

  Scenario: Pre-populating fields
    When I visit the new template page
    Then the "Name" field should be blank
    And the template's content field should be blank

    When I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then the "Name" field should contain "Home"
    And the template's content field should contain "some content"

    When I visit the page for that template
    Then the "Name" field should contain "Home"
    And the template's content field should contain "some content"