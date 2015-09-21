FactoryGirl.define do

  factory :event do
    sequence(:name) { |n| "event#{n}" }
    description 'lorem ipsum forum terlo merdensk estur silan pereditta'
    start_time { Time.now + 1.day }
    end_time { Time.now + 2.day }
    association :creator, factory: :user, strategy: :build
  end

  factory :user do
    sequence(:name) { |n| "User#{n}" }
    title 'Mr'
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'my_password'
  end
end
