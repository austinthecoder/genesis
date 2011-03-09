Feature: Creating Templates

  Background:
    Given a user
    And I am signed in as that user
    And I follow "Theme"

##################################################

  Scenario: Simple
    When I follow "Add a template"
    And I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"
    And I should see "Home" within the templates within the sidebar

##################################################

  Scenario: Making sure name isn't blank
    When I follow "Add a template"
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input within the template form

    When I fill in "Name" with "Home"
    And I press "Save this template"
    And I fill in "Name" with ""
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "can't be blank" within the name input within the template form

##################################################

  Scenario: Making sure name is unique per user
    Given another user
    And a template for the other user named "Home"

    When I follow "Add a template"
    And I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"

    When I follow "Theme"
    And I follow "Add a template"
    And I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "has already been taken" within the name input within the template form

##################################################

  Scenario: Continual editing
    When I follow "Add a template"
    And I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then the "Name" field should contain "Home"
    And the template's content field should contain "some content"

    When I follow "Home" within the templates within the sidebar
    Then the "Name" field should contain "Home"
    And the template's content field should contain "some content"

    When I fill in "Name" with "Home changed"
    And I fill in the template's content with "some content changed"
    And I press "Save this template"
    Then the "Name" field should contain "Home changed"
    And the template's content field should contain "some content changed"

    When I follow "Home" within the templates within the sidebar
    Then the "Name" field should contain "Home changed"
    And the template's content field should contain "some content changed"

##################################################

  Scenario: Users should only see templates belonging to them
    Given a user with the email "john@example.com"
    And templates for that user with the attributes:
      | Name |
      | Tpl1 |
      | Tpl2 |
    And a user
    And templates for that user with the attributes:
      | Name |
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

    When I sign out
    And I sign in as the user with the email "john@example.com"
    And I follow "Theme"
    Then I should see each of the following within the templates:
      | Tpl1 |
      | Tpl2 |
    And I should not see each of the following within the templates:
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

    When I follow "Theme"
    And I follow "Add a template"
    Then I should see each of the following within the templates within the sidebar:
      | Tpl1 |
      | Tpl2 |
    And I should not see each of the following within the templates within the sidebar:
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

    When I press "Save this template"
    Then I should see each of the following within the templates within the sidebar:
      | Tpl1 |
      | Tpl2 |
    And I should not see each of the following within the templates within the sidebar:
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

    When I follow "Theme"
    And I follow "Tpl1"
    Then I should see each of the following within the templates within the sidebar:
      | Tpl1 |
      | Tpl2 |
    And I should not see each of the following within the templates within the sidebar:
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

    When I fill in "Name" with ""
    And I press "Save this template"
    Then I should see each of the following within the templates within the sidebar:
      | Tpl1 |
      | Tpl2 |
    And I should not see each of the following within the templates within the sidebar:
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

##################################################

  Scenario: Removing
