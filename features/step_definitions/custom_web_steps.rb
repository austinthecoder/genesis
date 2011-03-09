When /^(.+) within ([^:]+):$/ do |step, scope_str, table|
  with_scope(scope_to(scope_str)) { When "#{step}:", table }
end

When /^(.+) within ([^:]+)$/ do |step, scope_str|
  with_scope(scope_to(scope_str)) { When step }
end

##################################################

Then /^I should see each of the following:$/ do |table|
  table.raw.flatten.each do |text|
    page.should have_content(text)
  end
end

Then /^I should not see each of the following:$/ do |table|
  table.raw.flatten.each do |text|
    page.should have_no_content(text)
  end
end

Then /^I should not see the "([^"]*)" field$/ do |field|
  lambda { find_field(field) }.should raise_error(Capybara::ElementNotFound)
end