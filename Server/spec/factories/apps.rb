# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app do
    sequence(:name) { |n| "App #{n}" }
    sequence(:identifier)
    sequence(:key) { |n| "key-#{n}" }
    sequence(:url) { "App #{:name}" }
    app_type 'iOS'
    association :team, factory: :team
  end
end
