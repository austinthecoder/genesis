Feature: Admin Sign-out

  Scenario: Sign out
    Given a site
    And a user for that site
    And I am signed in as that user

    When I follow "Sign out"
    Then I should see "Signed out successfully."