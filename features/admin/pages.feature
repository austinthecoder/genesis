Feature: Pages

  Background:
    Given a user
    And I am signed in as that user

  Scenario: Creating a page
    When I follow "Pages"
    And I follow "Add the Home page"
    Then I should see "Permalink /"

    When I press "Save"
    Then I should see "can't be blank" within the title input

    When I fill in "Title" with "Home"
    And I press "Save"
    Then I should see "Page was added."

    When I follow "Home" within the list of pages
    Then the "Title" field should contain "Home"
    And I should see "Permalink /"

    When I follow "Pages"
    Then I should not see "Add the Home page"

    When I follow "add subpage" within the page with the title "Home"
    And I fill in "Title" with "About"
    And I press "Save"
    Then I should see "can't be blank" within the permalink input

    When I fill in "Permalink" with "about"
    And I press "Save"
    Then I should see "Page was added."

    When I follow "About" within the page with the title "Home"