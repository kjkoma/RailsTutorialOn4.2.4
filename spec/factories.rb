FactoryGirl.define do
  factory :user do
    name     "kijima01"
    email    "kj@mail01.com"
    password "foobar"
    password_confirmation "foobar"
  end
end