When /^I add a "([^"]*)" page for (that template)$/ do |title, template|
  steps %{
    When I follow:
      | Pages | Add the Home page |
    And I fill in "Title" with "#{title}"
    And I select "#{template.name}" from "Template"
    And I press "Save"
  }
end