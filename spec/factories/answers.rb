# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
      question_id 1
      gist "MyString"
    end
end