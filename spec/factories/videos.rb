# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    panda_id "MyString"
    duration 1
    width 1
    height 1
    encoding_id 1
    screenshot "MyString"
    url "MyString"
    original_filename "MyString"
  end
end
