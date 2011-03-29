Given /^I have an? "([^"]*)" page for that template$/ do |page_title|
  When %{I add a "#{page_title}" page for that template}
end

Given /^I have an? "([^"]*)" page$/ do |page_title|
  When %{I add a "#{page_title}" page}
end

Given /^I have an? "([^"]*)" page for that page$/ do |page_title|
  When %{I add a "#{page_title}" page for that page}
end

Given /^I have an? "([^"]*)" page for the "([^"]*)" page$/ do |page_title1, page_title2|
  When %{I add a "#{page_title1}" page for the "#{page_title2}" page}
end

##################################################

When /^I add an? "([^"]*)" page$/ do |page_title|
  steps %{
    When I visit the new page page
    And I fill in "Title" with "#{page_title}"
    And I press "Save"
  }
end

When /^I add an? "([^"]*)" page for the "([^"]*)" page$/ do |page_title1, page_title2|
  permalink = page_title1.downcase.gsub(/\s+/, '-')
  steps %{
    When I visit the new subpage page for the "#{page_title2}" page
    And I fill in the following:
      | Title     | #{page_title1} |
      | Permalink | #{permalink}  |
    And I press "Save"
  }
end

When /^I add an? "([^"]*)" page for (that page)$/ do |page_title, parent_page|
  When %{I add a "#{page_title}" page for the "#{parent_page.title}" page}
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

When /^I remove the "([^"]*)" page$/ do |page_title|
  steps %{
    When I visit the pages page
    And I press "remove" within the row for the "#{page_title}" page
  }
end