Given(/^a user$/) { create_user }

Given /^a user with the attributes:$/ do |table|
  table = table.transpose
  table.map_headers! { |h| h.downcase.gsub(/\s/, '_').to_sym }
  create_user(table.transpose.rows_hash)
end

Given /^(that user) is signed in$/ do |user|
  steps %{
    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | #{user.email}               |
      | Password | #{@user_passwords[user.id]} |
    And I press "Sign in"
  }
end

##################################################

def create_user(attrs = {})
  @user_passwords ||= {}
  Factory(:user, attrs).tap { |u| @user_passwords[u.id] = attrs[:password] }
end