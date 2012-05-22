require 'backbone_helpers'

class Contact
  include Mongoid::Document
  include BackboneHelpers::Model
  
  belongs_to :user
  has_many :addresses, :autosave => true, :dependent => :destroy
  embeds_many :phones
  embeds_many :socials
  embeds_many :notes
  embeds_many :emails
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true
  accepts_nested_attributes_for :socials, :allow_destroy => true
  accepts_nested_attributes_for :emails, :allow_destroy => true

  field :name, :type => String
  field :position, :type => String
  #field :email, :type => String
  field :dob, :type => Date
  field :is_user, :type => Boolean, :default => false
  field :favorite_ids, :type => Array, :default => []
  field :avatar, :type => String, :default => "http://placehold.it/80x80"
  field :map, :type => Array, :default => []
  field :facebook_id, :type => String
  #field :favorite_users, :type => Array
  
  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :addresses
    t.add :phones
    t.add :socials
    t.add :notes
    t.add :emails
    t.add :name
    t.add :email
    t.add :dob
    t.add :avatar
    t.add :map
    t.add :facebook_id
  end

  def update_attributes_from_api(params)
    keys_with_nested_attributes = ["addresses", "phones", "socials", "notes", "emails"]
    params = api_to_nested_attributes(params, keys_with_nested_attributes)
    update_attributes(params)
  end

  def as_json(options = nil)
    super((options || {}).merge(include: { addresses: { only: [:postcode, :coordinates] }, socials: {}}))
  end
end
