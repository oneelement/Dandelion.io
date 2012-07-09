require 'backbone_helpers'

class Url
  include Mongoid::Document
  
  belongs_to :contact
  belongs_to :group
  
  field :text, :type => String
  field :default, :type => Boolean, :default => false

  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :_type
    t.add :text
    t.add :default
  end
  
  api_accessible :group do |t|
    t.add :_id
    t.add :_type
    t.add :text
    t.add :default
  end
end