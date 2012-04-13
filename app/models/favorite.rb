class Favorite
  include Mongoid::Document
  
  belongs_to :user
  
  field :favorite_id, :type => String
end
