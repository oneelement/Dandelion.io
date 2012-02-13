class Section
  include Mongoid::Document

  has_many :policy_sections

  embedded_in :product
  embeds_many :questions
  accepts_nested_attributes_for :questions, :allow_destroy => true

  field :name, :type => String
end
