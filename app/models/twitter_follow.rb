class TwitterFollow
  include Mongoid::Document
  
  belongs_to :user
  
  field :name
  field :twitter_id
  field :contact_id
  field :avatar
  field :handle
  field :screen_name
  field :location
  field :url
end
