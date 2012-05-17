require 'backbone_helpers'

class Group  
  include Mongoid::Document
  include BackboneHelpers::Model
  
  belongs_to :user
  embeds_many :notes
  embeds_many :phones
  embeds_many :socials
  has_many :addresses, :autosave => true, :dependent => :destroy
  
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :socials, :allow_destroy => true
  
  field :name, :type => String
  field :web, :type => String
  field :email, :type => String
  field :avatar, :type => String, :default => "http://placehold.it/80x80"
  field :map, :type => Array, :default => []
  field :contact_ids, :type => Array, :default => []
  
  acts_as_api

  api_accessible :group do |t|
    t.add :_id
    t.add :addresses
    t.add :phones
    t.add :socials
    t.add :notes
    t.add :name
    t.add :email
    t.add :avatar
    t.add :map
    t.add :contact_ids
  end

  def update_attributes_from_api(params)
    keys_with_nested_attributes = ["addresses", "notes", "phones", "socials"]
    params = api_to_nested_attributes(params, keys_with_nested_attributes)
    update_attributes(params)
  end
end
