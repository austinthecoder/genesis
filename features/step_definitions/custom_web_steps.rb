When /^(.+) within ([^:]+):$/ do |step, scope_str, table|
  with_scope(scope_to(scope_str)) { When "#{step}:", table }
end

When /^(.+) within ([^:]+)$/ do |step, scope_str|
  with_scope(scope_to(scope_str)) { When step }
end

When /^I follow:$/ do |table|
  table.raw.flatten.each do |link|
    When %{I follow "#{link}"}
  end
end

When /^I visit the fields page for (that template)$/ do |template|
  steps %{
    When I follow:
      | Theme | #{template.name} | template data |
  }
end

When /^I visit the page for (that page)$/ do |page|
  steps %{
    When I follow:
      | Pages | #{page.title} |
  }
end

##################################################

# Then /^I should see each of the following:$/ do |table|
#   table.raw.flatten.each do |text|
#     page.should have_content(text)
#   end
# end

# Then /^I should not see each of the following:$/ do |table|
#   table.raw.flatten.each do |text|
#     page.should have_no_content(text)
#   end
# end

Then /^I should not see the "([^"]*)" field$/ do |field|
  lambda { find_field(field) }.should raise_error(Capybara::ElementNotFound)
end

Then /^I should see the "([^"]*)" field$/ do |field|
  lambda { find_field(field) }.should_not raise_error
end