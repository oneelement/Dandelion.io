class Phone
  include Mongoid::Document

  embedded_in :contact

  #to do Add country code to phone -- think skype icons etc
  field :phone_number, :type => String
  field :phone_type, :type => String

  #Validation
  #validates_presence_of :phone_number
  #validates_presence_of :phone_type
end
