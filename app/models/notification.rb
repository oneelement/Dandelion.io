require 'backbone_helpers'

class Notification
  include Mongoid::Document
  
  belongs_to :user
  
  field :sent_id, :type => String
  field :target_id, :type => String
  field :sent_name, :type => String
  field :sent_avatar, :type => String
  field :is_read, :type => Boolean, :default => false
  field :is_actioned, :type => Boolean, :default => false
  
  acts_as_api

  api_accessible :notification do |t|
    t.add :_id
    t.add :_type
    t.add :sent_id
    t.add :sent_avatar
    t.add :sent_name
    t.add :user_id
    t.add :is_read
    t.add :is_actioned
  end
end
