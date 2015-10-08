FactoryGirl.define do
  factory :order do
    beverage 'chai'
    location 'here'
    temperature 'cold'
    user
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@salesforce.com" }
    password '12345678'
    encrypted_password { password }
  end
end

