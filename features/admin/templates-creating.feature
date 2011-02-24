Feature: Creating Templates

  Background:
    Given a user
    And that user is signed in
    And I am on the template creation page


  Scenario: Simple
    And I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"


  Scenario: Making sure name isn't blank
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input within the template form


  Scenario: Making sure name is unique per user
    Given another user
    And a template for the other user named "Home"

    When I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"

    When I go to the template creation page
    And I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "has already been taken" within the name input within the template form