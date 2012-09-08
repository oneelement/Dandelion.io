class FacebookFriend
  include Mongoid::Document
  
  belongs_to :user
  
  has_many :positions, :autosave => true, :dependent => :destroy
  has_many :educations, :autosave => true, :dependent => :destroy
  
  accepts_nested_attributes_for :positions, :allow_destroy => true
  accepts_nested_attributes_for :locations, :allow_destroy => true
  
  field :name
  field :facebook_id
  field :contact_id
  field :location
  field :url
end
