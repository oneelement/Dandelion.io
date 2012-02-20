#A pre-determined value for an answer, e.g. a drop down answer
class PossibleAnswer
  include Mongoid::Document

  belongs_to :possible_answer_group
  field :value, :type => String
  validates_presence_of :value
end
