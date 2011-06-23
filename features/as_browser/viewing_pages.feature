Feature: Viewing pages

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user

  Scenario: Home page - basic
    Given I have a "Home" template:
      """
      Home template
      """
    And I have a "Home" page for that template

    When I visit "http://example.com/"
    Then I should see "Home template"

##################################################

  Scenario: Sub page - basic
    Given I have a "Home" template:
      """
      Home template
      """
    And I have a "Home" page
    And I have an "About" page for that page for that template

    When I visit "http://example.com/about"
    Then I should see "Home template"

##################################################

  Scenario: Home page with a field
    Given I have a "Home" template:
      """
      Home template
      {{ page['Body'] }}
      """
    And I have a "Body" field for that template
    And I have a "Home" page for that template:
      | Body | page body here |

    When I visit "http://example.com/"
    Then I should see each of the following:
      | Home template  |
      | page body here |