# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :build do
    association(:repository)
    last_commit_id { "1234567890" }
    last_commit_message { "commit message" }
    position { 1 }
    duration { 1 }
    finished_at { "2012-05-12 13:00:26" }
    branch { "master" }
    warnings_count { 0 }
  end
end
