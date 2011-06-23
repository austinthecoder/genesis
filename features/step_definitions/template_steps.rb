Given /^I have a template$/ do
  When %{I add a template}
end

Given /^I have a "([^"]*)" template$/ do |tpl_name|
  When %{I add a "#{tpl_name}" template}
end

Given /^I have a "([^"]*)" template:$/ do |tpl_name, tpl_content|
  steps %{
    When I add a "#{tpl_name}" template:
      """
      #{tpl_content}
      """
  }
end

##################################################

When /^I fill in the template's content with "([^"]*)"$/ do |text|
  fill_in('template_content', :with => text)
end

Given /^I fill in the template's content with:$/ do |text|
  fill_in('template_content', :with => text)
end

When /^I remove that template$/ do
  steps %{
    When I follow "Theme"
    And I press "remove" within the row for that template
  }
end

When /^I add a template$/ do
  When %{I add a "Home" template}
end

When /^I add a "([^"]*)" template$/ do |tpl_name|
  steps %{
    When I visit the new template page
    And I fill in "Name" with "#{tpl_name}"
    And I press "Save this template"
  }
end

When /^I add a "([^"]*)" template:$/ do |tpl_name, tpl_content|
  steps %{
    When I visit the new template page
    And I fill in "Name" with "#{tpl_name}"
    And I fill in the template's content with:
      """
      #{tpl_content}
      """
    And I press "Save this template"
  }
end

##################################################

Then /^the template's content field should contain "([^"]*)"$/ do |value|
  field = find_field('template_content')
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should =~ /#{value}/
end

Then /^the template's content field should be blank$/ do
  field = find_field('template_content')
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should be_blank
end