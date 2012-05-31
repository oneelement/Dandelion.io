require 'backbone_helpers'

class Phone
  include Mongoid::Document

  embedded_in :contact
  embedded_in :group
  
  #to do Add country code to phone -- think skype icons etc
  field :number, :type => String
  field :default, :type => Boolean, :default => false
  field :icon, :type => String

  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :_type
    t.add :number
    t.add :default
    t.add :icon
  end
  
  api_accessible :group do |t|
    t.add :_id
    t.add :_type
    t.add :number
    t.add :default
    t.add :icon
  end
end
