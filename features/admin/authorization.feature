Feature: Authorization

  Scenario: Can't go to any admin page when not logged in
    When I go to the template creation page
    Then I should see "You need to sign in or sign up before continuing."