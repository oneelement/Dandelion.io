class Policy
  include Mongoid::Document

  belongs_to :product

  embeds_many :policy_sections
  accepts_nested_attributes_for :policy_sections, :allow_destroy => true

  field :name, :type => String
  field :status, :type => String
end
