Transform /(that user)/ do |step|
  User.last
end

Transform /(other user)/ do |step|
  User.last
end

Transform /(the user with the email "([^"]*)")/ do |step, email|
  User.find_by_email(email)
end