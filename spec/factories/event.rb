FactoryGirl.define do

  factory :event do
    sequence(:name) { |n| "event#{n}" }
    description 'lorem ipsum forum terlo merdensk estur silan pereditta'
    start_time { Time.now + 1.day }
    end_time { Time.now + 2.day }
    creator
  end

end
