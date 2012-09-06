require 'backbone_helpers'

class Url
  include Mongoid::Document
  include Mongoid::Paranoia
  
  belongs_to :contact
  belongs_to :group
  
  field :text, :type => String
  field :default, :type => Boolean, :default => false
  field :parent_id, :type => String
  
  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :_type
    t.add :text
    t.add :default
    t.add :parent_id
  end
  
  api_accessible :group do |t|
    t.add :_id
    t.add :_type
    t.add :text
    t.add :default
    t.add :parent_id
  end
  
  api_accessible :user_contact do |t|
    t.add :_id
    t.add :_type
    t.add :text
    t.add :default
  end
end