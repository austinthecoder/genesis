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

##################################################

  Scenario: Editing page fields
    # field exists before
    Given I have a "Home" template
    And I have a "body" field for that template

    When I add a "Home" page for that template
    Then I should see the "Body" field

    # adding a field
    When I add a "footer" field for that template
    And I visit the page for that page
    Then I should see the "Footer" field

    # saving field content
    When I fill in the following:
      | Body   | some body content   |
      | Footer | footer content here |
    And I press "Save"
    Then I should see "Page was saved."
    And the "Body" field should contain "some body content"
    And the "Footer" field should contain "footer content here"

    # removing fields
    When I remove the "body" field for that template
    And I visit the page for that page
    Then I should not see the "Body" field
    And the "Footer" field should contain "footer content here"

    When I remove the "footer" field for that template
    And I press "Undo"
    And I visit the page for that page
    Then the "Footer" field should contain "footer content here"

##################################################