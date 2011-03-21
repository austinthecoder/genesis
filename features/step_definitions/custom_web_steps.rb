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

Then /^the "([^"]*)" field should be blank$/ do |field|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should be_blank
end

Then /^I should see the "([^"]*)" button$/ do |locator|
  page.should have_button(locator)
end

Then /^I should not see the "([^"]*)" button$/ do |locator|
  page.should have_no_button(locator)
end

Then /^the "([^"]*)" field should be "([^"]*)"$/ do |field, value|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  field_value.should eq(value)
end