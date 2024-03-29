class Entity
  include Mongoid::Document

  has_many :users
  belongs_to :organisation

  accepts_nested_attributes_for :organisation
  field :name, :type => String
end
