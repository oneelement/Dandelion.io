class Address
  include Mongoid::Document

  referenced_in :contact

  field :name, :type => String
  field :line1, :type => String
  field :line2, :type => String
  field :line3, :type => String
  field :county, :type => String
  field :city, :type => String
  field :country, :type => String
  field :postcode, :type => String
  field :address_type, :type => String

  #Validation
  #validates_presence_of :line1
  #validates_presence_of :postcode
end
