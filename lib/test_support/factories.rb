FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:name) { |n| "name#{n}" }

  factory :user do
    email
    name 'John Smith'
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
    template
    title 'My Page'
  end

  factory :sub_page, :parent => :page do
    parent { Factory(:page) }
    slug "my-page"
  end

  factory :content do
    page
    field
  end

  factory :site do

  end
end