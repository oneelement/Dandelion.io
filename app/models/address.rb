class Address
  include Mongoid::Document
  include Geocoder::Model::Mongoid  
  
  geocoded_by :full_address
  after_validation :geocode

  belongs_to :contact

  field :name, :type => String
  field :line1, :type => String
  field :line2, :type => String
  field :line3, :type => String
  field :county, :type => String
  field :city, :type => String
  field :country, :type => String
  field :postcode, :type => String
  
  field :coordinates, :type => Array
  
  def full_address
    address = "#{self.line1}, #{self.line2}, #{self.city}, #{self.county}, #{self.postcode}"
    address = "#{address} #{self.country}"
    return address
  end


  #Validation
  #validates_presence_of :line1
  #validates_presence_of :postcode
end

class HomeAddress < Address
end

class BusinessAddress < Address
end

class CustomAddress < Address
  field :custom_name, :type => String
end


