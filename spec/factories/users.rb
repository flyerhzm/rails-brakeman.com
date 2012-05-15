# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@gmail.com" }
    password "testtest"
    password_confirmation "testtest"
  end
end

