class Authentication
  include Mongoid::Document
  embedded_in :user

  def self.available_providers 
    {
      :linkedin => 'LinkedIn',
      :facebook => 'Facebook'
    }
  end

  field :provider
  field :uid
end
