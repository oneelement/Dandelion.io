class Question
  include Mongoid::Document

  embeds_one :builder_details_container, :class_name => 'BuilderQuestionDetailsContainer'
  accepts_nested_attributes_for :builder_details_container

  embeds_one :question_type

  field :name, :type => String

  #scope :children_of, -> (section) { where("builder_details_container.section_id" => section.id) }

  scope :suggestions, where("builder_details_container.is_standard_question" => true)
  scope :custom, where("builder_details_container.is_standard_question" => false)
  
  acts_as_api

  api_accessible :question do |t|
    t.add :id
    t.add :name
    t.add :question_type, :template => :question_type
    t.add :builder_details_container
  end

end

#Some details about the question, used to assist the product/question set builder
class BuilderQuestionDetailsContainer
  include Mongoid::Document

  embedded_in :question, :inverse_of => :builder_details_container
  belongs_to :section
  #
  #Sensible default added by us, or bespoke section added by someone building a product?
  #Used to figure out whether or not to suggest the section to people
  field :is_standard_question, :type => Boolean, :default => false
end
