Feature: Creating Templates

  Background:
    Given a user
    And that user is signed in
    And I am on the template creation page


  Scenario: Simple
    When I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"


  Scenario: Making sure name isn't blank or taken
    When I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input within the template form