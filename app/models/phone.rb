class Phone
  include Mongoid::Document

  embedded_in :contact

  #to do Add country code to phone -- think skype icons etc
  field :number, :type => String

  def self.type_json_name
    ''
  end

  def type_json_name
    self.class.type_json_name
  end

  acts_as_api

  api_accessible :contact do |t|
    t.add :type_json_name, :as => :type
    t.add :number
  end


  #Validation
  #validates_presence_of :phone_number
  #validates_presence_of :phone_type
end
