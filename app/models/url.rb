require 'backbone_helpers'

class Url
  include Mongoid::Document
  
  embedded_in :contact
  embedded_in :group
  
  field :url, :type => String

  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :_type
    t.add :url
  end
  
  api_accessible :group do |t|
    t.add :_id
    t.add :_type
    t.add :url
  end
end