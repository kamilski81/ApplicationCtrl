#Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@appctrl.com" }
    password 'password'
    password_confirmation 'password'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
    association :team, factory: :team


    factory :admin do
      sequence(:email) { |n| "admin#{n}@appctrl.com" }
      is_admin true
      team nil
    end

  end
end
