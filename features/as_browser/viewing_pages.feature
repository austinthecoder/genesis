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
      Welcome
      {{ page['Title'] }}
      {{ page['Body'] }}
      """
    And I have a "Body" field for that template
    And I have a "Home" page for that template:
      | Body | <p>Thanks for visiting.</p> |

    When I visit "http://example.com/"
    Then I should see each of the following:
      | Welcome | Home | Thanks for visiting. |