When /^show me the url$/ do
  p current_url
end

When /^debug$/ do
  field = find_field('Type')
  p field.inspect
end