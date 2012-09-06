require 'backbone_helpers'

class Phone
  include Mongoid::Document
  include Mongoid::Paranoia

  belongs_to :contact
  belongs_to :group
  
  #to do Add country code to phone -- think skype icons etc
  field :number, :type => String
  field :default, :type => Boolean, :default => false
  field :icon, :type => String
  field :parent_id, :type => String

  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :contact_id
    t.add :_type
    t.add :number
    t.add :default
    t.add :icon
    t.add :parent_id
  end
  
  api_accessible :group do |t|
    t.add :_id
    t.add :group_id
    t.add :_type
    t.add :number
    t.add :default
    t.add :icon
    t.add :parent_id
  end
  
  api_accessible :user_contact do |t|
    t.add :_id
    t.add :contact_id
    t.add :_type
    t.add :number
    t.add :default
    t.add :icon
  end
end
