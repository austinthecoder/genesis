Feature: Creating Templates

  Scenario: Simple
    Given a user
    And that user is signed in

    When I go to the template creation page
    And I fill in "Content" with "some content"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"