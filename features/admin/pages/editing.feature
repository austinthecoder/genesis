Feature: Creating/Editing Pages

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user

  Scenario: Validations
    When I visit the new page page
    And I press "Save"
    Then I should see "can't be blank" within the title input

    When I fill in "Title" with "Home"
    And I press "Save"
    Then I should see "Page was saved."

    When I visit the page for that page
    And I fill in "Title" with ""
    And I press "Save"
    Then I should see "can't be blank" within the title input

    When I fill in "Title" with "Home2"
    And I press "Save"
    Then I should see "Page was saved."

    When I visit the new subpage page for that page
    And I fill in the following:
      | Title     | About Us |
      | Permalink | about/us |
    And I press "Save"
    Then I should see "is invalid" within the permalink input

    When I fill in "Permalink" with "about"
    And I press "Save"
    Then I should see "Page was saved."

##################################################

  Scenario: Pre-populating fields
    When I add a "Home" page
    Then the "Title" field should contain "Home"

    When I visit the page for that page
    Then the "Title" field should contain "Home"

    When I fill in "Title" with "The Homepage"
    And I press "Save"
    Then the "Title" field should contain "The Homepage"

    When I visit the new subpage page for that page
    And I fill in the following:
      | Title     | About |
      | Permalink | about |
    And I press "Save"
    And the "Permalink" field should contain "about"

    When I visit the page for that page
    Then the "Permalink" field should contain "about"

    When I fill in "Permalink" with "about-us"
    And I press "Save"
    Then the "Permalink" field should contain "about-us"

##################################################

  Scenario: Viewing the template field - with no templates
    When I visit the new page page
    Then I should not see the "Template" field

    When I add a "Home" page
    Then I should not see the "Template" field

##################################################

  Scenario: Viewing the template field - with templates
    Given I have a "Home" template

    When I visit the new page page
    Then I should see the "Template" field

    When I add a "Home" page
    Then I should see the "Template" field

    When I add an "About" page for that page for that template
    Then I should not see the "Template" field
    And I should see "Template Home"

##################################################

  Scenario: Viewing the permalink field
    When I visit the new page page
    Then I should not see the "Permalink" field

    When I add a "Home" page
    Then I should not see the "Permalink" field

    When I visit the new subpage page for that page
    Then I should see the "Permalink" field

    When I add an "About" page for that page
    Then I should see the "Permalink" field

##################################################

  Scenario: Viewing template-related fields
    Given I have a "Home" template
    And I have a "body" field for that template
    And I have a "foot" field for that template

    When I add a "Home" page for that template
    Then I should see the fields:
      | Body | Foot |

    When I remove the "body" field for that template
    And I visit the page for that page
    Then I should not see the "Body" field
    And I should see the "Foot" field

    When I add a "head" field for that template
    And I visit the page for that page
    Then I should not see the "Body" field
    And I should see the fields:
      | Head | Foot |

    When I remove that template
    And I visit the page for that page
    Then I should not see the fields:
      | Head | Body | Foot |

##################################################

  Scenario: Saving template-related field content
    Given I have a "Home" template
    And I have a "body" field for that template
    And I have a "Home" page for that template

    When I visit the page for that page
    And I fill in "Body" with "some content"
    And I press "Save"
    Then I should see "Page was saved."
    And the "Body" field should contain "some content"

##################################################

  Scenario: Persisting content after restoring a field
    Given I have a "Home" template
    And I have a "body" field for that template
    And I have a "Home" page for that template

    When I fill in "Body" with "some content"
    And I press "Save"
    And I remove the "body" field for that template
    And I press "Undo"
    And I visit the page for that page
    Then the "Body" field should contain "some content"

##################################################

  @wip
  Scenario: Persisting content after restoring a template

##################################################

  Scenario: Changing templates
    Given I have a "Home" template
    And I have a "body" field for that template
    And I have a "Blog" template
    And I have a "foot" field for that template
    And I have a "Home" page for that template

    When I follow "change" within the template section
    And I select "Home" from "Template"
    And I press "Save"
    Then I should see the "Body" field
    Then I should not see the "Foot" field