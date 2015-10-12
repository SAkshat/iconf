FactoryGirl.define do

  factory :user, aliases: [:creator, :speaker] do
    sequence(:name) { |n| "User#{n}" }
    title 'Mr'
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'my_password'
    password_confirmation 'my_password'
    enabled true

    factory :admin do
      admin true
    end
  end

end
