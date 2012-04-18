class Authentication
  include Mongoid::Document
  embedded_in :user

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
end
