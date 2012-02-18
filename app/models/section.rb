class Section
  include Mongoid::Document

  embeds_one :builder_metadata, :class_name => 'BuilderSectionMetadata'
  accepts_nested_attributes_for :builder_metadata

  field :name, :type => String
  validates_presence_of :name

  def suggested_questions
    builder_metadata.suggested_questions
  end

  def suggested_child_sections
    builder_metadata.suggested_child_sections
  end
end

#Some details about the section, used to assist the product/question set builder
class BuilderSectionMetadata
  include Mongoid::Document

  embedded_in :section, :inverse_of => :builder_metadata
  #Suggest the section at top level for a shell product? i.e. this section is not a child of another section
  field :is_top_level, :type => Boolean
  
  #Sensible default added by us, or bespoke section added by someone building a product?
  #Used to figure out whether or not to suggest the section to people
  field :is_standard_section, :type => Boolean 

  #Suggestion of some helper data that could be used in the question set builder interface
  #We can always easily add these later using awesome MONGO POWER!!
  #embeds_many :product_category_tags

  has_and_belongs_to_many :suggested_questions, :inverse_of => nil, :class_name => 'Question', :autosave => true
  has_and_belongs_to_many :suggested_child_sections, :inverse_of => nil, :class_name => 'Section', :autosave => true
end
