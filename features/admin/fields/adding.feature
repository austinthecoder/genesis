Feature: Template Fields

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user
    And I have a "Home" template
    And I follow "template data"

##################################################

  Scenario: Default fields
    Then I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |

##################################################

  Scenario: Basic adding
    When I fill in the name field with "body"
    And I select "long text" from "Type"
    And I press "Add"
    Then I should see "Kablam! Added!"
    And I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |
      | body       | long text  |

##################################################

  Scenario: Pre-populating fields
    Then the name field should be blank

    When I add a "body" field
    Then I should see "body" within the fields table

##################################################

  Scenario: Validations
    When I press "Add"
    Then I should see "Dag nabbit. There were some problems."
    And I should see "can't be blank" within the name input

    When I add a "body" field
    And I fill in the name field with "body"
    And I press "Add"
    Then I should see "Dag nabbit. There were some problems."
    And I should see "has already been taken" within the name input