FactoryGirl.define do

  factory :discussion do
    sequence(:name) { |n| "discussion#{n}" }
    topic 'lorem ipsum'
    date { Time.now + 30.hour }
    start_time { Time.now + 32.hour }
    end_time { Time.now + 33.hour }
    location 'Location1'
    description 'lorem ipsum merdetta genesk glorius latin geronimus ficus'
    enabled true
    event
    creator
    speaker
  end

end
