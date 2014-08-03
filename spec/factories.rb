FactoryGirl.define do
  factory :user do
    name      "John Rooney"
    email     "john.rooney@bleather.net"
    password  "foobar"
    password_confirmation "foobar"
  end
end
