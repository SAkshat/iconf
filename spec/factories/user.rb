FactoryGirl.define do

  factory :user, aliases: [:creator] do
    sequence(:name) { |n| "User#{n}" }
    title 'Mr'
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'my_password'
  end

end
