class Organisation
  include Mongoid::Document

  has_many :users
  has_many :entities
accepts_nested_attributes_for :users, :entity
  field :name, :type => String
end
