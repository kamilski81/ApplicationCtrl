# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    sequence(:description) { |n| "This is Team #{n}" }

    factory :team_with_users do

      ignore do
        users_count 15
        apps_count 5
      end

      after(:create) do |team, evaluator|
        create_list(:user, evaluator.users_count, team: team)
        create_list(:app_with_versions, evaluator.apps_count, team: team)
      end

    end

  end
end
