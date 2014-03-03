# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    sequence(:description) { |n| "This is Team #{n}" }
  end
end
