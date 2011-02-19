Feature: Admin Sign-in

  Scenario: Failed sign-in
    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | john@example.com |
      | Password | secret           |
    And I press "Sign in"
    Then I should see "Invalid email or password"