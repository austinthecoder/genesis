Feature: Pages

  Background:
    Given a user
    And I am signed in as that user

  Scenario: Creating a page
    When I follow "Pages"
    And I follow "Add the Home page"
    Then I should see "Permalink /"
    And I should see "Template" within the form

    When I press "Save"
    Then I should see "can't be blank" within the title input

    When I fill in "Title" with "Home"
    And I press "Save"
    Then I should see "Page was saved."
    And the "Title" field should contain "Home"

    When I follow "Pages"
    And I follow "Home" within the list of pages
    Then the "Title" field should contain "Home"
    And I should see "Permalink /"
    And I should not see "Template" within the form

    When I follow "Pages"
    Then I should not see "Add the Home page"

    When I follow "add subpage" within the page with the title "Home"
    And I fill in "Title" with "About"
    And I press "Save"
    Then I should see "can't be blank" within the permalink input

    When I fill in "Permalink" with "about/us"
    And I press "Save"
    Then I should see "is invalid" within the permalink input

    When I fill in "Permalink" with "about"
    And I press "Save"
    Then I should see "Page was saved."

    When I follow "Pages"
    Then I should see "About" within the page with the title "Home"



  Scenario: Creating a page with a template/editing
    Given a template with the name "Home" for that user

    When I follow "Pages"
    And I follow "Add the Home page"
    And I fill in "Title" with "Homepage"
    And I select "Home" from "Template"
    And I press "Save"
    Then I should see "Page was saved"
    Then I should not see the "Template" field

    When fields are added to that template with the attributes:
      | Name   | Type       |
      | Body   | long text  |
      | Footer | short text |
    And I go to the page for that page
    And I fill in "Body" with "this is the body"
    And I fill in "Footer" with "this is the footer"
    And I press "Save"
    Then I should see "Page was saved"

    When I remove the "Body" field for the "Home" template
    And I go to the page for the "Homepage" page
    Then I should not see the "Body" field