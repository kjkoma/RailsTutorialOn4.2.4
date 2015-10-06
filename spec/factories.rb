FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "Person_#{n}@railstutorial.jp"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
        admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end