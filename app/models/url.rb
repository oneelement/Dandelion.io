require 'backbone_helpers'

class Url
  include Mongoid::Document
  
  belongs_to :contact
  belongs_to :group
  
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