Given /^I have a "([^"]*)" field for that template$/ do |field_name|
  When %{I add a "#{field_name}" field for that template}
end

##################################################

When /^the following fields are added to that template:$/ do |table|
  When "I visit the fields page for that template"
  table.hashes.each do |attrs|
    And %{I fill in the name field with "#{attrs["Name"]}"}
    And %{I select "#{attrs["Type"]}" from the type field} if attrs["Type"]
    And %{I press "Add"}
  end
end

When /^I fill in the name field with "([^"]*)"$/ do |value|
  fill_in('field_name', :with => value)
end

When /^I select "([^"]*)" from the type field$/ do |value|
  select(value, :from => 'field_field_type')
end

When /^I remove the "([^"]*)" field for that template$/ do |field_name|
  steps %{
    When I visit the fields page for that template
    And I press "remove" within the row for the field with the name "#{field_name}"
  }
end

When /^I add a "([^"]*)" field for that template$/ do |field_name|
  steps %{
    When I visit the fields page for that template
    And I fill in the name field with "#{field_name}"
    And I press "Add"
  }
end

##################################################

Then /^I should see the fields table, which looks like:$/ do |expected_table|
  actual_table = tableish('table.fields tr', "th, td").to_a
  begin
    expected_table.diff! actual_table
  rescue Cucumber::Ast::Table::Different => e
    puts %{
actual:
#{actual_table.inspect}
expected:
#{expected_table.raw.inspect}
    }
    raise e
  end
end