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

  factory :field do
    name
    field_type Field::TYPE_OPTIONS.keys[0]
    template
  end

  factory :page do
    user
    title 'My Page'
  end

  factory :content do
  end
end