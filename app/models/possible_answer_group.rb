#A group of pre-determined answers, e.g. a drop down list
class PossibleAnswerGroup
  include Mongoid::Document

  has_many :possible_answers, :autosave => true
  accepts_nested_attributes_for :possible_answers

  field :name, :type => String
  validates_presence_of :name
end
