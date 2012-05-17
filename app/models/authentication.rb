require 'backbone_helpers'

class Authentication
  include Mongoid::Document
  belongs_to :user

  def self.available_providers 
    {
      :linkedin => 'LinkedIn',
      :facebook => 'Facebook',
      :twitter => 'Twitter'
    }
  end

  field :provider
  field :uid
  field :token
  field :secret
  
  acts_as_api

  api_accessible :user do |t|
    t.add :_id
    t.add :provider
    t.add :token
  end
  
end
