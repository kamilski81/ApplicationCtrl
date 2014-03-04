# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :versioning do
    profile 'v-0.1'
    sequence(:build)
    status 'WORKING'
    association :app, factory: :app
  end
end
