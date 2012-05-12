# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repository do
    github_id 1
    github_name "MyString"
    name "MyString"
    description "MyString"
    github_url "MyString"
    private false
    fork false
    pushed_at "2012-05-12 11:27:19"
  end
end
