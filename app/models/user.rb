require 'backbone_helpers'

class User 
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include BackboneHelpers::Model
  
  after_create :contact_create_manual
  before_save :full_name
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates_presence_of :email

  belongs_to :organisation, :autosave => true
  belongs_to :entity
  belongs_to :user_type
  
  has_many :contacts
  has_many :groups
  has_many :tasks
  has_many :hashtags
  has_many :favorites
  has_many :facebook_friends
  has_many :google_contacts
  has_many :linkedin_connections
  has_many :authentications, :autosave => true, :dependent => :destroy
  
  accepts_nested_attributes_for :organisation, :contacts, :groups, :tasks, :favorites
  accepts_nested_attributes_for :facebook_friends, :linkedin_connections, :google_contacts
  accepts_nested_attributes_for :hashtags
  accepts_nested_attributes_for :authentications, :allow_destroy => true
  
  ## Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Fields added after defaults
  field :first_name, :type => String
  field :last_name, :type => String
  field :full_name, :type => String
  field :avatar, :type => String
  field :contact_id, :type => String
  field :is_admin, :type => Boolean, :default => false
  field :is_mobile, :type => Boolean, :default => false
  field :favourite_contacts, :type => String
  field :recent_contacts, :type => String
  field :linked_contact_ids, :type => Array, :default => []
  #field :adminorg, :type => Boolean, :default => false
  #field :adminent, :type => Boolean, :default => false
  #field :adminone, :type => Boolean, :default => false
  #field :organisation, :type => String

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  
  acts_as_api

  api_accessible :user do |t|
    t.add :_id
    t.add :authentications
    t.add :first_name
    t.add :last_name
    t.add :full_name
    t.add :avatar
    t.add :email
    t.add :contact_id
    t.add :favourite_contacts
    t.add :recent_contacts
    t.add :linked_contact_ids
  end
  
  api_accessible :public_user do |t|
    t.add :_id
    t.add :first_name
    t.add :last_name
    t.add :full_name
    t.add :avatar
    t.add :contact_id
  end

  def update_attributes_from_api(params)
    keys_with_nested_attributes = ["authentications"]
    params = api_to_nested_attributes(params, keys_with_nested_attributes)
    update_attributes(params)
  end
  
  def contact_create_manual
    # assuming only facebook is used to sign in/up for now
    record = Contact.new(
      :name => self.first_name + " " +self.last_name, 
      :user_id => self._id, 
      :is_user => true
    )
    record.save
    record.emails.create!(
      :text => self.email,
      :_type => 'EmailPersonal'
    )
    self.contact_id = record._id
    self.full_name = self.first_name + ' ' + self.last_name
    self.save
  end
  
  
  def contact_update(omniauth)
    # assuming only facebook is used to sign in/up for now  
    record = Contact.find(self.contact_id)
    if omniauth['provider'] == 'facebook'
      facebook_id = omniauth['uid']
      facebook_handle = omniauth['extra']['raw_info']['link']
      
      if omniauth['extra']['raw_info']['work']
        positions = omniauth['extra']['raw_info']['work']
	i = 1
	positions.each do |pos|
	  if pos["employer"]["name"]
	    company = pos["employer"]["name"]
	  else
	    company = nil
	  end
	  if pos["position"]
	    title = pos["position"]["name"]
	  else
	    title = nil
	  end
	  if i == 1
	    current = true
	  else
	    current = false
	  end
	  record.positions.create!(
	    :title => title,
	    :company => company,
	    :current => current
	  )
	  i = i + 1
	end
      end
      
      if omniauth['extra']['raw_info']['education']
	educations = omniauth['extra']['raw_info']['education']
	educations.each do |edu|
	  if edu["school"]["name"]
	    title = edu["school"]["name"]
	  else
	    title = nil
	  end
	  if edu["year"]
	    year = edu["year"]["name"]
	  else
	    year = nil
	  end
	  if edu["type"]
	    if edu["type"] == "High School"
	    type = "EducationSchool"
	    elsif edu["type"] == "College"
	    type = "EducationCollege"
	    end
	  else
	    type = "Education"
	  end
	  record.educations.create!(
	    :title => title,
	    :year => year,
	    :_type => type
	  )
        end
      end
      
      if omniauth['extra']['raw_info']['website']
        url = omniauth['extra']['raw_info']['website']
        record.urls.create!(
          :text => url,
          :_type => 'UrlPersonal'
        )
      end
      
      if omniauth['extra']['raw_info']['location']
        location = omniauth['extra']['raw_info']['location']
        record.addresses.create!(
          :full_address => location['name'],
          :_type => 'AddressPersonal'
        )
      end      
      
    else
      facebook_id = nil
      facebook_handle = nil
    end    
    record.avatar = self.avatar
    record.facebook_picture = self.avatar
    record.facebook_id = facebook_id
    record.facebook_handle = facebook_handle    
    record.save
  end
  
  #def as_json(options = nil)
    #super((options || {}).merge(include: { authentications: { only: [:token, :provider, :_id] } }))
  #end
  
  def full_name
    #"#{first_name} #{last_name}"
    self.full_name = self.first_name + ' ' + self.last_name
  end

  def authenticated_with?(auth)
    return (authentications.where(:provider => auth.to_s).count > 0)
  end
  
  #def apply_omniauth(omniauth)
    #authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  #end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] unless omniauth['info']['email'].blank?
    apply_trusted_services(omniauth) if self.new_record?
  end
  
  def apply_trusted_services(omniauth) 
    #info = omniauth['info']
    #if omniauth['extra'] && omniauth['extra']['user_hash']
      #user_info.merge!(omniauth['extra']['user_hash'])
    #end 
    if self.first_name.blank?
      if omniauth['info']['first_name']
	self.first_name = omniauth['info']['first_name'] unless omniauth['info']['first_name'].blank? #"joe" #(user_info['first_name']) unless user_info['first_name'].blank?
      elsif omniauth['info']['name']
	self.first_name = omniauth['info']['name'] unless omniauth['info']['name'].blank?
      elsif omniauth['info']['nickname']
	self.first_name = omniauth['info']['nickname'] unless omniauth['info']['nickname'].blank?
      end
    end  
    if self.last_name.blank?
      if omniauth['info']['last_name']
	self.last_name = omniauth['info']['last_name'] unless omniauth['info']['last_name'].blank? #"joe" #(user_info['first_name']) unless user_info['first_name'].blank?
      else
	self.last_name = ""
      end
    end  
    if self.email.blank?
      if omniauth['info']['email']
	self.email = omniauth['info']['email'] unless omniauth['info']['email'].blank? #"joe" #(user_info['first_name']) unless user_info['first_name'].blank?
      else
	self.email = "" #user_info['email'] unless user_info['email'].blank?
      end
    end 
    if omniauth['info']['image']
      self.avatar = omniauth['info']['image'] unless omniauth['info']['image'].blank?
    end
    self.password, self.password_confirmation = String::RandomString(16) 
    self.user_type_id = UserType.get_consumer.id
  end
  
  
  def tweeting
    provider = self.authentications.where(:provider => 'twitter').first
    if provider
      Twitter.configure do |config|
        config.consumer_key = 'ABP2ZruFX54U9FpM3HOzNg'
        config.consumer_secret = '7sk9KK4mraEdpv9vvJfgeySnLsukauxOwQeK88WuhA'
        config.oauth_token = provider.token
        config.oauth_token_secret = provider.secret
      end
      @tweeting ||= Twitter::Client.new
    end
  end
  
  def facebook
    provider = self.authentications.where(:provider => 'facebook').first
    if provider
      @facebook ||= Koala::Facebook::API.new(provider.token)
    end
  end
  
  def linkedin
    provider = self.authentications.where(:provider => 'linkedin').first    
    if provider
      client = LinkedIn::Client.new('5bhck1eg3l0i', 'c8IO2JxzHp74OvtQ')
      client.authorize_from_access(provider.token, provider.secret)
      @linkedin ||= client
    end
  end
  
    
  def google
    provider = self.authentications.where(:provider => 'google_oauth2').first    
    if provider
      client = Google::APIClient.new
      client.authorization.access_token = provider.token
      #client.authorization.update_token!(provider.token)
      #client.authorize_from_access(provider.token, provider.secret)
      @google ||= client
    end
  end
  
end
