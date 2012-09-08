class LinkedinConnection
  include Mongoid::Document
  
  belongs_to :user
  
  has_many :positions, :autosave => true, :dependent => :destroy
  
  accepts_nested_attributes_for :positions, :allow_destroy => true
  
  field :name
  field :linkedin_id
  field :contact_id
  field :avatar
  field :handle
  field :location
end
