require 'backbone_helpers'

class Social
  include Mongoid::Document

  embedded_in :contact
  embedded_in :group
  
  field :social_id, :type => String
  
  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :_type
    t.add :social_id
  end

end
