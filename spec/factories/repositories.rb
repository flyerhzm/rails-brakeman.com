# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repository do
    sequence(:github_id) { |n| n }
    association(:user)
    github_name "flyerhzm/test"
    name "test"
    description "test"
    git_url "git://github.com/flyerhzm/test.git"
    ssh_url "git@github.com:flyerhzm/test.git"
    html_url "https://github.com/flyerhzm/test"
    private false
    rails true
    fork false
    pushed_at "2012-05-12 11:27:19"
  end
end
