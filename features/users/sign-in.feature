Feature: Admin Sign-in

  Scenario: Validations
    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | john@example.com |
      | Password | secret           |
    And I press "Sign in"
    Then I should see "Invalid email or password"

##################################################

  Scenario: Can't sign in to another site
    Given a site
    And a user with the attributes:
      | Email    | john@example.com |
      | Password | secret           |

    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | john@example.com |
      | Password | secret           |
    And I press "Sign in"
    Then I should see "Invalid email or password"

##################################################

  Scenario: Can sign in to my own site
    Given a site
    And a user for that site with the attributes:
      | Email                 | steve@example.com |
      | Name                  | Steve Smith       |
      | Password              | secret            |
      | Password Confirmation | secret            |

    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | steve@example.com |
      | Password | secret           |
    And I press "Sign in"
    Then I should see "Signed in successfully"
    And I should see "Welcome, Steve Smith"