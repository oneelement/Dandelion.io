class Social
  include Mongoid::Document

  embedded_in :contact
  field :social_id, :type => String

  def self.type_json_name 
    ''
  end

  def type_json_name
    self.class.type_json_name
  end

  acts_as_api

  api_accessible :contact do |t|
    t.add :type_json_name, :as => :type
    t.add :social_id
  end

end

