Feature: Template Fields

  Background:
    Given a site
    And a user for that site
    And I am signed in as that user
    And I have a "Home" template

##################################################

  Scenario: Viewing and adding a field
    When I follow "Theme"
    And I follow "Home"
    And I follow "template data"
    Then I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |

    # adding a field
    When I fill in "Name" with "body"
    And I select "long text" from "Type"
    And I press "Add"
    Then I should see "Kablam! Added!"
    And I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |
      | body       | long text  |

    # adding another field, using default type
    When I fill in "Name" with "footer"
    And I press "Add"
    Then I should see "Kablam! Added!"
    And I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |
      | body       | long text  |
      | footer     | short text |

    # validations
    When I fill in "Name" with ""
    And I press "Add"
    Then I should see "Dag nabbit. There were some problems."
    And I should see "can't be blank" within the name input
    And I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |
      | body       | long text  |
      | footer     | short text |

    When I fill in "Name" with "body"
    And I press "Add"
    Then I should see "Dag nabbit. There were some problems."
    And I should see "has already been taken" within the name input
    And I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |
      | body       | long text  |
      | footer     | short text |

    # removing a field
    When I press "remove" within the row for the field with the name "body"
    Then I should see "Field was removed."
    And I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |
      | footer     | short text |

    # undoing remove
    When I press "Undo"
    Then I should see "Field was added back."
    And I should see the fields table, which looks like:
      | Name       | Type       |
      | page title | short text |
      | permalink  | short text |
      | body       | long text  |
      | footer     | short text |