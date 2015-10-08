FactoryGirl.define do

  factory :discussion do
    sequence(:name) { |n| "discussion#{n}" }
    topic 'lorem ipsum'
    date { Date.new }
    start_time { Time.now + 1.day }
    end_time { Time.now + 2.day }
    location 'Location1'
    description 'lorem ipsum merdetta genesk glorius latin'
    enabled true

    factory :disabled_event do
      enabled false
    end
  end

end
