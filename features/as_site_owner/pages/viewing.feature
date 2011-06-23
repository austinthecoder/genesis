Feature: Viewing Pages

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user

##################################################

  Scenario: Template required to create pages
    When I follow "Pages"
    Then I should see "There are no templates"
    And I should see "Before creating pages, you must create a template. Create one now."