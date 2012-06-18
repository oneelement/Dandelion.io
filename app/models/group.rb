require 'backbone_helpers'

class Group  
  include Mongoid::Document
  include BackboneHelpers::Model
  
  belongs_to :user
  embeds_many :notes
  embeds_many :phones
  embeds_many :socials
  embeds_many :emails
  embeds_many :urls
  has_many :addresses, :autosave => true, :dependent => :destroy
  has_and_belongs_to_many :hashtags, :autosave => true
  
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :socials, :allow_destroy => true
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :urls, :allow_destroy => true
  accepts_nested_attributes_for :hashtags
  
  field :name, :type => String
  field :web, :type => String
  #field :email, :type => String
  field :avatar, :type => String, :default => "http://placehold.it/80x80"
  field :map, :type => Array, :default => []
  field :contact_ids, :type => Array, :default => []
  field :facebook_id, :type => String
  field :linkedin_id, :type => String
  field :twitter_id, :type => String
  field :facebook_picture, :type => String
  field :twitter_picture, :type => String
  field :linkedin_picture, :type => String

  
  acts_as_api

  api_accessible :group do |t|
    t.add :_id
    t.add :addresses
    t.add :phones
    t.add :socials
    t.add :notes
    t.add :emails
    t.add :urls
    t.add :name
    #t.add :email
    t.add :avatar
    t.add :map
    t.add :contact_ids
    t.add :facebook_id
    t.add :linkedin_id
    t.add :twitter_id
    t.add :facebook_picture
    t.add :twitter_picture
    t.add :linkedin_picture
    t.add :hashtags
  end

  def update_attributes_from_api(params)
    keys_with_nested_attributes = ["addresses", "notes", "phones", "socials", "emails",  "urls", "hashtags"]
    params = api_to_nested_attributes(params, keys_with_nested_attributes)
    update_attributes(params)
  end
end
