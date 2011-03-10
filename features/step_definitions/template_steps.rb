Given /^I have a "([^"]*)" template$/ do |template_name|
  When %{I add a "#{template_name}" template}
end

##################################################

When /^I fill in the template's content with "([^"]*)"$/ do |text|
  fill_in('template_content', :with => text)
end

When /^I remove that template$/ do
  steps %{
    When I follow "Theme"
    And I press "remove" within the row for that template
  }
end

When /^I add a "([^"]*)" template$/ do |template_name|
  steps %{
    When I follow:
      | Theme | Add a template |
    And I fill in "Name" with "#{template_name}"
    And I press "Save this template"
  }
end

##################################################

Then /^the template's content field should contain "([^"]*)"$/ do |value|
  field = find_field('template_content')
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should =~ /#{value}/
end