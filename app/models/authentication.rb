class Authentication
  include Mongoid::Document
  embedded_in :user

  def self.allowed_providers 
    {
      :linkedin => 'LinkedIn'
    }
  end

  field :provider
  field :uid
end
