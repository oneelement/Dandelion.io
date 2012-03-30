class UserType
  include Mongoid::Document
  
  has_many :users
  
  field :name, :type => String
  
  def self.get_entity
    usertype = UserType.where(:name => "Entity")
    return usertype.first
  end
  
  def self.get_organisation
    usertype = UserType.where(:name => "Organisation")
    return usertype.first
  end
  
  def self.get_consumer
    usertype = UserType.where(:name => "Consumer")
    return usertype.first
  end
  
end
