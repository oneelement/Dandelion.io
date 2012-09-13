require 'backbone_helpers'

class Contact
  include Mongoid::Document
  include Mongoid::Paranoia
  include BackboneHelpers::Model
  
  before_destroy :clean_contact_delete
  
  belongs_to :user
  
  has_many :addresses, :autosave => true, :dependent => :destroy
  has_many :phones, :autosave => true, :dependent => :destroy
  has_many :notes, :autosave => true, :dependent => :destroy
  has_many :emails, :autosave => true, :dependent => :destroy
  has_many :urls, :autosave => true, :dependent => :destroy
  has_many :positions, :autosave => true, :dependent => :destroy
  has_many :educations, :autosave => true, :dependent => :destroy
  
  has_and_belongs_to_many :hashtags, :autosave => true
  
  embeds_many :socials
  
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :notes, :allow_destroy => true
  accepts_nested_attributes_for :socials, :allow_destroy => true
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :urls, :allow_destroy => true
  accepts_nested_attributes_for :positions, :allow_destroy => true
  accepts_nested_attributes_for :educations, :allow_destroy => true
  #accepts_nested_attributes_for :hashtags, :allow_destroy => true #this this will delte

  field :name, :type => String
  field :dob, :type => Date
  field :location, :type => String
  field :current_position, :type => String
  field :current_company, :type => String
  field :is_user, :type => Boolean, :default => false
  field :is_ripple, :type => Boolean, :default => false
  field :linked_contact_id, :type => String
  field :linked_user_ids, :type => Array, :default => []
  field :favorite_ids, :type => Array, :default => []
  field :group_ids, :type => Array, :default => []
  field :avatar, :type => String
  field :map, :type => Array, :default => []
  field :facebook_id, :type => String
  field :linkedin_id, :type => String
  field :twitter_id, :type => String
  field :facebook_picture, :type => String
  field :twitter_picture, :type => String
  field :linkedin_picture, :type => String
  field :facebook_handle
  field :twitter_handle
  field :linkedin_handle
  #field :favorite_users, :type => Array
  
  acts_as_api

  api_accessible :contact do |t|
    t.add :_id
    t.add :addresses
    t.add :phones
    t.add :socials
    t.add :notes
    t.add :emails
    t.add :urls
    t.add :positions
    t.add :educations
    t.add :name
    t.add :is_ripple
    t.add :is_user
    t.add :linked_contact_id
    t.add :dob
    t.add :location
    t.add :current_position
    t.add :current_company
    t.add :avatar
    t.add :map
    t.add :facebook_id
    t.add :linkedin_id
    t.add :twitter_id
    t.add :facebook_picture
    t.add :twitter_picture
    t.add :linkedin_picture
    t.add :facebook_handle
    t.add :twitter_handle
    t.add :linkedin_handle
    #t.add :hashtags
    t.add :group_ids
  end
  
  api_accessible :public_contact do |t|
    t.add :_id
    t.add :name
    t.add :avatar
    t.add :facebook_id
    t.add :linkedin_id
    t.add :twitter_id
    t.add :facebook_picture
    t.add :twitter_picture
    t.add :linkedin_picture
  end
  
  api_accessible :user_contact do |t|
    t.add :_id
    t.add :addresses
    t.add :phones
    t.add :emails
    t.add :urls
    t.add :positions
    t.add :educations
    t.add :name
  end
  
  def clean_contact_delete
    face = FacebookFriend.where(:user_id => self.user_id, :contact_id => self._id).first
    if face
      face.contact_id = ""
      face.save
    end
  end
  
  def update_linkedin(uid)
    @user = User.find(self.user_id)
    profile = @user.linkedin.profile(:id => uid, :fields => [:headline, :first_name, :last_name, :public_profile_url, :picture_url, :summary, :educations, :positions, :location])
    if profile.positions.total > 0
      positions = profile.positions.all
      positions.each do |pos|
	if pos.is_current
	  current = pos.is_current
	else
	  current = nil
	end
	if pos.title
	  title = pos.title
	else
	  title = nil
	end
	if pos.company.name
	  company = pos.company.name
	else
	  company = nil
	end
	self.positions.create!(
	  :title => title,
	  :company => company,
	  :current => current
	)
      end 
    end
    if profile.educations.total > 0
      educations = profile.educations.all
      educations.each do |edu|
	if edu.school_name
	  title = edu.school_name
	else
	  title = nil
	end
        if edu.end_date
	  year = edu.end_date.year
	else
	  year = nil
	end
	if edu.field_of_study
	  subject = edu.field_of_study
	else
	  subject = nil
	end
	if edu.degree
	  grade = edu.degree
	else
	  grade = nil
	end
	self.educations.create!(
	  :title => title,
	  :subject => subject,
	  :grade => grade,
	  :year => year,
	  :_type => 'Education'
	)
      end 
    end
    if profile.location.name
      self.addresses.create!(
	:full_address => profile.location.name,
	:_type => 'AddressPersonal'
      )
    end
  end
  
  def self.update_user_contacts
    user_contacts = Contact.where(:is_user => true)
    
    contacts = Contact.all
    
    contacts.each do |c|
      if c.linked_contact_id?
	puts 'true'
	puts c.name
	puts c.linked_contact_idlinked_contact_id
	puts c.facebook_id
      else
	#puts 'false'
	#puts c.name
	#puts c.facebook_id
	user_contacts.each do |uc|
	  #puts 'USER'
	  #puts uc.name
	  #puts uc.facebook_id
	  #puts c.name
	  if uc.facebook_id? && (uc.facebook_id == c.facebook_id)
	    #puts 'START'
	    #puts c.name
	    #puts c.facebook_id
	    #puts uc.name
	    #puts uc.facebook_id
	    c.linked_contact_id = uc._id
	    c.save
	    puts 'FINISH'
	  end
	end
      end
    end
        
  end

  def update_attributes_from_api(params)
    keys_with_nested_attributes = ["addresses", "phones", "socials", "notes", "emails", "urls", "positions", "educations", "hashtags"]
    params = api_to_nested_attributes(params, keys_with_nested_attributes)
    update_attributes(params)
  end

  def as_json(options = nil)
    super((options || {}).merge(include: { addresses: { only: [:postcode, :coordinates] }, socials: {}}))
  end
end
