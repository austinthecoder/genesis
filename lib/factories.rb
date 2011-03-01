FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:name) { |n| "name#{n}" }

  factory :user do
    email
    password 'secret'
    password_confirmation 'secret'
  end

  factory :template do
    name
    user
  end
end