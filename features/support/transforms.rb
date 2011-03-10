Transform /(that user)/ do |step|
  User.last
end

Transform /(other user)/ do |step|
  User.last
end

##################################################

Transform /(that template)/ do |step|
  Template.last
end

##################################################

Transform /(that page)/ do |step|
  Page.last
end