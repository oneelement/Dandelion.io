require 'backbone_helpers'

class Contact
  include Mongoid::Document
  include BackboneHelpers::Model
  
  before_destroy :clean_contact_delete
  
  belongs_to :user
  
  has_many :addresses, :autosave => true, :dependent => :destroy
  has_many :phones, :autosave => true, :dependent => :destroy
  has_many :notes, :autosave => true, :dependent => :destroy
  has_many :emails, :autosave => true, :dependent => :destroy
  has_many :urls, :autosave => true, :dependent => :destroy
  
  has_and_belongs_to_many :hashtags, :autosave => true
  
  embeds_many :socials
  
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true
  accepts_nested_attributes_for :socials, :allow_destroy => true
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :urls, :allow_destroy => true
  accepts_nested_attributes_for :hashtags, :allow_destroy => true #this this will delte

  field :name, :type => String
  field :position, :type => String
  #field :email, :type => String
  field :dob, :type => Date
  field :is_user, :type => Boolean, :default => false
  field :favorite_ids, :type => Array, :default => []
  field :avatar, :type => String, :default => "http://placehold.it/80x80"
  field :map, :type => Array, :default => []
  field :facebook_id, :type => String
  field :linkedin_id, :type => String
  field :twitter_id, :type => String
  field :facebook_picture, :type => String
  field :twitter_picture, :type => String
  field :linkedin_picture, :type => String
  #field :favorite_users, :type => Array
  
  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :addresses
    t.add :phones
    t.add :socials
    t.add :notes
    t.add :emails
    t.add :urls
    t.add :name
    #t.add :email
    t.add :dob
    t.add :avatar
    t.add :map
    t.add :facebook_id
    t.add :linkedin_id
    t.add :twitter_id
    t.add :facebook_picture
    t.add :twitter_picture
    t.add :linkedin_picture
    t.add :hashtags
  end
  
  def clean_contact_delete
    face = FacebookFriend.where(:user_id => self.user_id, :contact_id => self._id).first
    if face
      face.contact_id = ""
      face.save
    end
  end

  def update_attributes_from_api(params)
    keys_with_nested_attributes = ["addresses", "phones", "socials", "notes", "emails", "urls", "hashtags"]
    params = api_to_nested_attributes(params, keys_with_nested_attributes)
    update_attributes(params)
  end

  def as_json(options = nil)
    super((options || {}).merge(include: { addresses: { only: [:postcode, :coordinates] }, socials: {}}))
  end
end
