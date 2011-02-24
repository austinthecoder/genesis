FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }

  factory :user do
    email
    password 'secret'
    password_confirmation 'secret'
  end

  factory :template do
    name "home"
    user
  end
end