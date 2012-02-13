class Product
  include Mongoid::Document

  has_many :policies

  embeds_many :sections
  accepts_nested_attributes_for :sections, :allow_destroy => true

  field :name, :type => String
end
