Given /^I have a "([^"]*)" page for that template$/ do |page_title|
  When %{I add a "#{page_title}" page for that template}
end

##################################################

When /^I add an? "([^"]*)" page$/ do |page_title|
  steps %{
    When I visit the new page page
    And I fill in "Title" with "#{page_title}"
    And I press "Save"
  }
end

When /^I add an? "([^"]*)" page for that page$/ do |page_title|
  permalink = page_title.downcase.gsub(/\s+/, '-')
  steps %{
    When I visit the new subpage page for that page
    And I fill in the following:
      | Title     | #{page_title} |
      | Permalink | #{permalink}  |
    And I press "Save"
  }
end

When /^I add an? "([^"]*)" page for (that template)$/ do |page_title, tpl|
  steps %{
    When I visit the new page page
    And I fill in "Title" with "#{page_title}"
    And I select "#{tpl.name}" from "Template"
    And I press "Save"
  }
end

When /^I add an? "([^"]*)" page for that page for (that template)$/ do |page_title, tpl|
  permalink = page_title.downcase.gsub(/\s+/, '-')
  steps %{
    When I visit the new subpage page for that page
    And I fill in the following:
      | Title     | #{page_title} |
      | Permalink | #{permalink}  |
    And I select "#{tpl.name}" from "Template"
    And I press "Save"
  }
end