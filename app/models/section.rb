class Section
  include Mongoid::Document

  belongs_to :product
  has_many :questions, :autosave => true
  accepts_nested_attributes_for :questions, :allow_destroy => true

  field :name, :type => String
end
