require 'backbone_helpers'

class Hashtag
  include Mongoid::Document
  
  belongs_to :user
  has_and_belongs_to_many :contacts
  has_and_belongs_to_many :groups
  
  
  
  field :text, :type => String
  

end
