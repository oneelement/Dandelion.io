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
end
