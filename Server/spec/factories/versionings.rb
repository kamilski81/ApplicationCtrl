# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :versioning do
    sequence(:version) { |n| "v-#{n}" }
    sequence(:build)
    status 'WORKING'
    association :app, factory: :app
  end
end
