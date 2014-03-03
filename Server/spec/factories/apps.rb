# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app do
    sequence(:name) { |n| "App #{n}" }
    sequence(:identifier)
    sequence(:key) { |n| "key-#{n}" }
    sequence(:url) { "http://#{name}.apple.com" }
    app_type 'iOS'
    association :team, factory: :team

    factory :app_with_versions do
      ignore do
        versions_count 12
      end

      after(:create) do |app, evaluator|
        create_list(:versioning, evaluator.versions_count, app: app)
      end
    end
  end
end
