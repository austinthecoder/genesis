Feature: Viewing Templates

  Scenario: Users should only see their templates
    Given a user with the email "john@example.com"
    And templates for that user with the attributes:
      | Name |
      | Tpl1 |
      | Tpl2 |
    And a user with the email "sally@example.com"
    And templates for that user with the attributes:
      | Name |
      | Tpl3 |
      | Tpl4 |
      | Tpl5 |

    When I sign in as the user with the email "john@example.com"
    And I go to the theme page
    Then I should see "Tpl1" within the templates
    And I should see "Tpl2" within the templates
    And I should not see "Tpl3" within the templates
    And I should not see "Tpl4" within the templates
    And I should not see "Tpl5" within the templates

    When I sign out
    And I sign in as the user with the email "sally@example.com"
    And I go to the theme page
    Then I should see "Tpl3" within the templates
    And I should see "Tpl4" within the templates
    And I should see "Tpl5" within the templates
    And I should not see "Tpl1" within the templates
    And I should not see "Tpl2" within the templates