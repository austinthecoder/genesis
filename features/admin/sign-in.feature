Feature: Admin Sign-in

  Scenario: Failed sign-in
    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | john@example.com |
      | Password | secret           |
    And I press "Sign in"
    Then I should see "Invalid email or password"


  Scenario: Successful sign-in
    Given a user with the attributes:
      | Email                 | steve@example.com |
      | Password              | secret            |
      | Password Confirmation | secret            |

    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | steve@example.com |
      | Password | secret           |
    And I press "Sign in"
    Then I should see "Signed in successfully"


  Scenario: Sign out
    Given a user
    And that user is signed in

    When I follow "Sign out"
    Then I should see "Signed out successfully."