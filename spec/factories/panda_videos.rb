# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video, class: ::PandaVideo do
    panda_id "MyString"
    duration 1
    width 1
    height 1
    encoding_id 1
    screenshot "MyString"
    url "MyString"
    original_filename "MyString"

    factory :unencoded_video do
      url { nil }
      screenshot { nil }
    end
  end
end
