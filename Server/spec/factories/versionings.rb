# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :versioning do
    version "MyString"
    build "MyString"
    warning false
    force_update false
    association :app, factory: :app
  end
end
