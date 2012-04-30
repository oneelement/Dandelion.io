class FacebookFriend
  include Mongoid::Document
  
  belongs_to :user
  
  field :name
  field :facebook_id
  field :contact_id
end
