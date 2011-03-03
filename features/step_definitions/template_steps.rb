Given /^templates for (that user) with the attributes:$/ do |user, table|
  table.map_headers! { |h| h.downcase.gsub(/\s/, '_').to_sym }
  table.hashes.each do |attrs|
    Factory(:template, attrs.merge(:user => user))
  end
end

Given /^a template with the name "([^"]*)" for (that user)$/ do |name, user|
  @template = Factory(:template, :name => name, :user => user)
end

##################################################

When /^I fill in the template's content with "([^"]*)"$/ do |text|
  fill_in('template_content', :with => text)
end

##################################################

Then /^the template's content field should contain "([^"]*)"$/ do |value|
  field = find_field('template_content')
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should =~ /#{value}/
end