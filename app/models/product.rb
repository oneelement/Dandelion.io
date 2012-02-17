class Product
  include Mongoid::Document

  has_many :policies

  has_many :sections, :autosave => true
  accepts_nested_attributes_for :sections, :allow_destroy => true

  field :name, :type => String
end
