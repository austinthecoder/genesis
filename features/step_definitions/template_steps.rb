Given /^templates for (that user) with the attributes:$/ do |user, table|
  table.map_headers! { |h| h.downcase.gsub(/\s/, '_').to_sym }
  table.hashes.each do |attrs|
    Factory(:template, attrs.merge(:user => user))
  end
end

When /^I fill in the template's content with "([^"]*)"$/ do |text|
  fill_in('template_content', :with => text)
end