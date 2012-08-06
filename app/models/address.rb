require 'backbone_helpers'

class Address
  include Mongoid::Document
  include Mongoid::Paranoia
  include Geocoder::Model::Mongoid  

  geocoded_by :full_address
  after_validation :geocode
  
  #after_create :check_subject_map

  belongs_to :contact
  belongs_to :group

  field :name, :type => String
  field :line1, :type => String
  field :line2, :type => String
  field :line3, :type => String
  field :county, :type => String
  field :city, :type => String
  field :country, :type => String
  field :postcode, :type => String
  field :default, :type => Boolean, :default => false
  
  field :coordinates, :type => Array
  
  def check_subject_map
    if self.contact_id
      id = self.contact_id
      contact = Contact.find(id)
      #contact.map << self.coordinates[0]
      #contact.map << self.coordinates[1]
      contact.save
    end
  end

  def full_address=(address_string)
    #Not really sure how we're gonna go about this... for now I will shove it in line1. Need to discuss
    self.line1= address_string
  end
  
  def full_address
    address_components = [self.line1, self.line2, self.line3, 
      self.county, self.postcode]

    for_output = address_components.select {|comp| (comp != nil && comp != '') }

    return for_output.join(', ')
  end

  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :_type
    t.add :full_address
    t.add :coordinates
    t.add :default
  end
  
  api_accessible :group do |t|
    t.add :_id
    t.add :_type
    t.add :full_address
    t.add :coordinates
    t.add :default
  end
  
  api_accessible :user_contact do |t|
    t.add :_id
    t.add :_type
    t.add :full_address
    t.add :coordinates
    t.add :default
  end

end
