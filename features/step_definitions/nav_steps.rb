### fields ###

When /^I visit the fields page for the "([^"]*)" template$/ do |tpl_name|
  steps %{
    When I visit the page for the "#{tpl_name}" template
    And I follow "Template data"
  }
end

When /^I visit the fields page for (that template)$/ do |tpl|
  When %{I visit the fields page for the "#{tpl.name}" template}
end


### templates ###

When /^I visit the new template page$/ do
  steps %{
    When I follow:
      | Theme | Add a template |
  }
end

When /^I visit the page for (that template)$/ do |tpl|
  steps %{
    When I follow:
      | Theme | #{tpl.name} |
  }
end

When /^I visit the page for the "([^"]*)" template$/ do |template_name|
  steps %{
    When I follow:
      | Theme | #{template_name} |
  }
end


### pages ###

When /^I visit the pages page$/ do
  When %{I follow "Pages"}
end

When /^I visit the page for (that page)$/ do |page|
  steps %{
    When I visit the pages page
    And I follow "#{page.title}"
  }
end

When /^I visit the new page page$/ do
  steps %{
    When I visit the pages page
    And I follow "Add the Home page"
  }
end

When /^I visit the new subpage page for the "([^"]*)" page$/ do |page_title|
  steps %{
    When I visit the pages page
    And I follow "add subpage" within the page with the title "#{page_title}"
  }
end

When /^I visit the new subpage page for (that page)$/ do |page|
  When %{I visit the new subpage page for the "#{page.title}" page}
end