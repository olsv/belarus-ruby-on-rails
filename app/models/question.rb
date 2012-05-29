class Question < ActiveRecord::Base
  RESPONSE_TYPES = %w(dropdown checkboxes text_field).freeze
  attr_accessible :answers_attributes, :gist, :kind_of_response
  belongs_to  :meetup
  has_many    :answers
  has_many    :quizzes, :dependent => :destroy
  accepts_nested_attributes_for :answers

  validates :gist, :presence => true

  RESPONSE_TYPES.each do |t|
    define_method("#{t}?") do
      RESPONSE_TYPES.index(t) == kind_of_response
    end
  end

  def self.response_type_options_for_select
    RESPONSE_TYPES.map { |r| [human_attribute_name(r), RESPONSE_TYPES.index(r)] }
  end

  def self.answer_options_for_select
    answers.map(&:gist)
  end
end