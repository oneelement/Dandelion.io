class Contact
  include Mongoid::Document
  
  belongs_to :user
  has_many :addresses, :autosave => true, :dependent => :destroy
  embeds_many :phones
  embeds_many :socials
  embeds_many :notes
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true

  field :name, :type => String
  field :email, :type => String
  field :dob, :type => Date
  field :is_user, :type => Boolean, :default => false
  field :favorite_ids, :type => Array, :default => []
  #field :favorite_users, :type => Array
  
  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :addresses
    t.add :phones
    t.add :socials
    t.add :notes
    t.add :name
    t.add :email
    t.add :dob
  end

  
  def as_json(options = nil)
    super((options || {}).merge(include: { addresses: { only: [:postcode, :coordinates] }, socials: {}}))
  end
end
