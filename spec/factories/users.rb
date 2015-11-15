FactoryGirl.define do
  factory :user do
    username 'Test_user'
    password '12345678'
    email 't@t.pl'
    phone 123_456_789
  end
end
