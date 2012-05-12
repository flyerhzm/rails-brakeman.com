# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :build do
    repository nil
    last_commit_id "MyString"
    last_commit_message "MyString"
    position 1
    duraion 1
    finished_at "2012-05-12 13:00:26"
    branch "MyString"
  end
end
