class Section
  include Mongoid::Document

  embeds_one :builder_details_container, :class_name => 'BuilderSectionDetailsContainer'
  accepts_nested_attributes_for :builder_details_container

  field :name, :type => String
  validates_presence_of :name

  scope :top_level, where("builder_details_container.is_top_level" => true)
  #scope :children_of, ->(section) { where("builder_details_container.section_id" => section.id) }

  scope :suggestions, where("builder_details_container.is_standard_section" => true)
  scope :custom, where("builder_details_container.is_standard_section" => false)

  acts_as_api

  api_accessible :section do |t|
    t.add :id
    t.add :name
    t.add :builder_details_container
  end
end

#Some details about the section, used to assist the product/question set builder
class BuilderSectionDetailsContainer
  include Mongoid::Document

  embedded_in :section, :inverse_of => :builder_details_container
  belongs_to :section #The parent section of the section (may not be present)

  #Suggest the section at top level for a shell product? i.e. this section is not a child of another section
  field :is_top_level, :type => Boolean, :default => false
  
  #Sensible default added by us, or bespoke section added by someone building a product?
  #Used to figure out whether or not to suggest the section to people
  field :is_standard_section, :type => Boolean, :default => false

  #Suggestion of some helper data that could be used in the question set builder interface
  #We can always easily add these later using awesome MONGO POWER!!
  #embeds_many :product_category_tags
  
  field :repeats, :type => Boolean, :default => false
  field :repeat_max_instances, :type => Integer, :default => 1

  acts_as_api

  api_accessible :section do |t|
    t.add :is_top_level
    t.add :is_standard_section
    t.add :repeats
    t.add :repeat_max_instances
  end
end
