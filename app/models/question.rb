class Question
  include Mongoid::Document

  embeds_one :builder_metadata, :class_name => 'BuilderQuestionMetadata'
  belongs_to :section
  belongs_to :question_type

  accepts_nested_attributes_for :builder_metadata

  validates_presence_of :section

  field :name, :type => String

  delegate :suggested_possible_answer_group, :to => :builder_metadata
end
#
#Some details about the question, used to assist the product/question set builder
class BuilderQuestionMetadata
  include Mongoid::Document

  embedded_in :question, :inverse_of => :builder_metadata

  belongs_to :suggested_possible_answer_group, :class_name => 'PossibleAnswerGroup', :autosave => true
end
