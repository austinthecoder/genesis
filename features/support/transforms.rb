Transform /^(that site)$/ do |step|
  Site.last
end

##################################################

Transform /^(that user)$/ do |step|
  User.last
end

Transform /^(other user)$/ do |step|
  User.last
end

##################################################

Transform /^(that template)$/ do |step|
  Template.last
end

##################################################

Transform /^(that page)$/ do |step|
  Page.last
end

Transform /^(the "([^"]*)" page)$/ do |step, page_title|
  Page.find_by_title(page_title)
end