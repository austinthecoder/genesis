Feature: Creating Templates

  Background:
    Given a user
    And that user is signed in
    And I am on the template creation page

##################################################

  Scenario: Simple
    When I fill in "Name" with "Home"
    And I fill in the template's content with "some content"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"
    And I should see "Home" within the templates within the sidebar

##################################################

  Scenario: Making sure name isn't blank
    When I press "Save this template"
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

    When I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Wowza weeza! Template was created!"

    When I go to the template creation page
    And I fill in "Name" with "Home"
    And I press "Save this template"
    Then I should see "Houston, we have some problems."
    And I should see "has already been taken" within the name input within the template form

##################################################

  Scenario: Continual editing
    When I fill in "Name" with "Home"
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
    And I go to the theme page
    Then I should see each of the following within the templates:
      | Tpl1 |
      | Tpl2 |
    And I should not see each of the following within the templates:
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

    When I go to the template creation page
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

    When I go to the edit page for the template with the name "Tpl1"
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