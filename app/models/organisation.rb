class Organisation
  include Mongoid::Document

  has_many :users
accepts_nested_attributes_for :users
  field :name, :type => String
end
