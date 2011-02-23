When /^I fill in the template's content with "([^"]*)"$/ do |text|
  fill_in('template_content', :with => text)
end