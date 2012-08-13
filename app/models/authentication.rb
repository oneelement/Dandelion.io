require 'backbone_helpers'

class Authentication
  include Mongoid::Document
  include Mongoid::Paranoia
  
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
  field :url
  field :image
  
  acts_as_api

  api_accessible :user do |t|
    t.add :_id
    t.add :provider
    t.add :token
    t.add :url
    t.add :image
  end
  
end
