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

When /^I visit the page for (that template)$/ do |tpl|
  steps %{
    When I follow:
      | Theme | #{tpl.name} |
  }
end

When /^I visit the fields page for that template$/ do
  steps %{
    When I visit the page for that template
    And I follow "template data"
  }
end

When /^I visit the page for (that page)$/ do |page|
  steps %{
    When I follow:
      | Pages | #{page.title} |
  }
end

When /^I visit the new page page$/ do
  steps %{
    When I follow:
      | Pages | Add the Home page |
  }
end

When /^I visit the new subpage page for (that page)$/ do |page|
  steps %{
    When I follow "Pages"
    And I follow "add subpage" within the page with the title "#{page.title}"
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

Then /^I should not see the fields:$/ do |table|
  table.raw.flatten.each do |field|
    Then %{I should not see the "#{field}" field}
  end
end

Then /^I should see the fields:$/ do |table|
  table.raw.flatten.each do |field|
    Then %{I should see the "#{field}" field}
  end
end