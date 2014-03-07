# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :versioning do
    profile '1.0'
    sequence(:build)
    status { [0, 1, 2].sample }
    association :app, factory: :app
  end
end
