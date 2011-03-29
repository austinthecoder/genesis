Given /^I have a "([^"]*)" field for that template$/ do |field_name|
  When %{I add a "#{field_name}" field for that template}
end

##################################################

When /^I fill in the name field with "([^"]*)"$/ do |value|
  fill_in('field_name', :with => value)
end

Then /^the name field should be blank$/ do
  find_field('field_name').value.should be_blank
end

When /^I remove the "([^"]*)" field for that template$/ do |field_name|
  steps %{
    When I visit the fields page for that template
    And I press "remove" within the row for the "#{field_name}" field
  }
end

When /^I remove (that field)$/ do |field|
  tpl = field.template
  steps %{
    When I visit the fields page for the "#{tpl.name}" template
    And I press "remove" within the row for the "#{field.name}" field
  }
end

When /^I add a "([^"]*)" field$/ do |field_name|
  steps %{
    When I fill in the name field with "#{field_name}"
    And I press "Add"
  }
end

When /^I add a "([^"]*)" field for that template$/ do |field_name|
  steps %{
    When I visit the fields page for that template
    And I add a "#{field_name}" field
  }
end

##################################################

Then /^I should see the fields table, which looks like:$/ do |expected_table|
  actual_table = tableish('table.fields tr', "th, td").to_a
  begin
    expected_table.diff! actual_table
  rescue Cucumber::Ast::Table::Different => e
    puts <<-EOS.strip_heredoc
      actual:
      #{actual_table.inspect}
      expected:
      #{expected_table.raw.inspect}
    EOS
    raise e
  end
end