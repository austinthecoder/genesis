Given /^I am signed in as (that user)$/ do |user|
  sign_in(user)
end

##################################################

When /^I sign in as (the user with the email "[^"]*")$/ do |user|
  sign_in(user)
end

When /^I sign out$/ do
  When %{I follow "Sign out"}
end

##################################################

def sign_in(user)
  steps %{
    When I go to the admin sign-in page
    And I fill in the following:
      | Email    | #{user.email}               |
      | Password | #{@user_passwords[user.id]} |
    And I press "Sign in"
  }
end