class Question
  include Mongoid::Document

  embeds_one :builder_metadata, :class_name => 'BuilderQuestionMetadata'
  belongs_to :section
  embeds_one :question_type

  accepts_nested_attributes_for :builder_metadata

  validates_presence_of :section

  field :name, :type => String
  
  acts_as_api

  api_accessible :question do |t|
    t.add :id
    t.add :name
    t.add :question_type, :template => :question_type
  end

end

#Some details about the question, used to assist the product/question set builder
class BuilderQuestionMetadata
  include Mongoid::Document

  embedded_in :question, :inverse_of => :builder_metadata
end
