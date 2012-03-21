class QuestionType
  include Mongoid::Document

  class_attribute :display_name
  self.display_name = 'Question'

  def display_name
    self.class.display_name
  end

  acts_as_api

  api_accessible :question_type do |t|
    t.add :_type
    t.add :display_name
  end
end

class AddressQuestionType < QuestionType
  self.display_name = 'Address'
end

class FreetextQuestionType < QuestionType
  self.display_name = 'Freetext'
  field :max_length, :type => Integer, :default => 200
end

class NumericQuestionType < QuestionType
  self.display_name = 'Numeric'
  field :decimal_places, :type => Integer, :default => 0
end

class PercentageQuestionType < NumericQuestionType
  self.display_name = 'Percentage'
end

class PossibleAnswerQuestionType < QuestionType
  self.display_name = 'Dropdown'
  belongs_to :possible_answer_group
end
