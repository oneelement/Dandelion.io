class Contact
  include Mongoid::Document

  references_many :addresses, :autosave => true
  embeds_many :phones
  accepts_nested_attributes_for :phones
  accepts_nested_attributes_for :addresses

  field :name, :type => String
end
