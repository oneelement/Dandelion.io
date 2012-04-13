class Contact
  include Mongoid::Document

  belongs_to :user
  has_many :addresses, :autosave => true, :dependent => :destroy
  embeds_many :phones
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true

  field :name, :type => String
  field :favorite_ids, :type => Array, :default => []
  #field :favorite_users, :type => Array
  
  def as_json(options = nil)
    super((options || {}).merge(include: { addresses: { only: [:postcode, :coordinates] } }))
  end
end
