require 'backbone_helpers'

class Education
  include Mongoid::Document
  include Mongoid::Paranoia

  belongs_to :contact
  belongs_to :facebook_friend
  #belongs_to :group
  
  field :title, :type => String
  field :year, :type => String
  field :current, :type => Boolean, :default => false
  field :default, :type => Boolean, :default => false
  field :icon, :type => String
  field :parent_id, :type => String

  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :contact_id
    t.add :title
    t.add :year
    t.add :default
    t.add :icon
    t.add :parent_id
  end
  
 
  api_accessible :user_contact do |t|
    t.add :_id
    t.add :contact_id
    t.add :title
    t.add :year
    t.add :default
    t.add :icon
  end
end
