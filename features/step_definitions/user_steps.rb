Given(/^a user$/) { create_user }

Given(/^another user$/) { create_user }

Given /^a user with the email "([^"]*)"$/ do |email|
  create_user(:email => email)
end

Given /^a user with the attributes:$/ do |table|
  table = table.transpose
  table.map_headers! { |h| h.downcase.gsub(/\s/, '_').to_sym }
  create_user(table.transpose.rows_hash)
end

Given /^a template for the (other user) named "([^"]*)"$/ do |user, template_name|
  Factory(:template, :name => template_name, :user => user)
end

##################################################

def create_user(attrs = {})
  @user_passwords ||= {}
  u = Factory(:user, attrs)
  @user_passwords[u.id] = u.password
end