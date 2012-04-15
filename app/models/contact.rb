class Contact
  include Mongoid::Document
  
  belongs_to :user
  has_many :addresses, :autosave => true, :dependent => :destroy
  embeds_many :phones
  embeds_many :socials
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true

  field :name, :type => String
  field :email, :type => String
  field :dob, :type => Date
  field :is_user, :type => Boolean, :default => false
  field :favorite_ids, :type => Array, :default => []
  #field :favorite_users, :type => Array

  
  def as_json(options = nil)
    super((options || {}).merge(include: { addresses: { only: [:postcode, :coordinates] } }))
  end
end
