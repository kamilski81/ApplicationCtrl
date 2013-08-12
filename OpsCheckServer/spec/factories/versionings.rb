# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :versioning do
    version "MyString"
    text "MyString"
    status 1
    references ""
  end
end
