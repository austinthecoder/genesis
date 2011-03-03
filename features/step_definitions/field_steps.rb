When /^I fill in the name field with "([^"]*)"$/ do |value|
  fill_in('field_name', :with => value)
end

When /^I select "([^"]*)" from the type field$/ do |value|
  select(value, :from => 'field_field_type')
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