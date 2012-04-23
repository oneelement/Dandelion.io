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

  def self.type_json_name
    ''
  end

  def type_json_name
    self.class.type_json_name
  end
  
  def full_address
    address = "#{self.line1}, #{self.line2}, #{self.city}, #{self.county}, #{self.postcode}"
    address = "#{address} #{self.country}"
    return address
  end

  acts_as_api

  api_accessible :contact do |t|
    t.add :type_json_name, :as => :type
    t.add :full_address
    t.add :coordinates
  end

end
