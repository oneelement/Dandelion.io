class QuestionAnswer
  include Mongoid::Document

  belongs_to :question

  embedded_in :policy_section, :inverse_of => :question_answers

  field :name, :type => String
end
