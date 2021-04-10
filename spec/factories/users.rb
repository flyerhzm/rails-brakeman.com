# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:github_uid) { |i| i }
    sequence(:email) { |i| "user#{i}@gmail.com" }
    sequence(:nickname) { |i| "user#{i}" }
    password { "testtest" }
    password_confirmation { "testtest" }
  end
end

