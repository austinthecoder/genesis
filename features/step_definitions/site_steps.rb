Given /^a site$/ do
  Factory(:site, :domain => host)
end

Given /^a site with the domain "([^"]*)"$/ do |domain|
  Factory(:site, :domain => domain)
end