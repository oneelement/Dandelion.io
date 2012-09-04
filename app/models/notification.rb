require 'backbone_helpers'

class Notification
  include Mongoid::Document
  include Mongoid::Paranoia
  
  belongs_to :user
  
  field :sent_id, :type => String
  field :sent_contact_id, :type => String
  field :sent_name, :type => String
  field :sent_avatar, :type => String
  field :ripple_id, :type => String
  field :is_read, :type => Boolean, :default => false
  field :is_actioned, :type => Boolean, :default => false
  field :is_synced, :type => Boolean, :default => false
  
  acts_as_api

  api_accessible :notification do |t|
    t.add :_id
    t.add :_type
    t.add :ripple_id
    t.add :sent_id
    t.add :sent_avatar
    t.add :sent_name
    t.add :sent_contact_id
    t.add :user_id
    t.add :is_read
    t.add :is_actioned
    t.add :is_synced
  end
end
