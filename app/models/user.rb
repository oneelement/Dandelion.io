class User 
  include Mongoid::Document
  
  after_create :contact_create
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organisation, :autosave => true
  belongs_to :entity
  belongs_to :user_type
  
  has_many :contacts
  has_many :groups
  has_many :tasks
  has_many :favorites
  has_many :facebook_friends
  has_many :authentications, :dependent => :delete
  
  accepts_nested_attributes_for :organisation, :contacts
  
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
  field :contact_id, :type => String
  field :is_admin, :type => Boolean, :default => false
  field :favorite_ids, :type => Array
  field :recent_ids, :type => Array
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
  
  def contact_create
    record = Contact.new(:name => self.first_name + " " +self.last_name, :user_id => self._id, :is_user => true)
    record.save
    self.contact_id = record._id
    self.save
  end
  
  def as_json(options = nil)
    super((options || {}).merge(include: { authentications: { only: [:token, :provider] } }))
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def authenticated_with?(auth)
    return (authentications.where(provider: auth.to_s).count > 0)
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
    self.password, self.password_confirmation = String::RandomString(16) 
    self.user_type_id = UserType.get_consumer.id
  end
  
  
  def tweeting
    provider = self.authentications.where(:provider => 'twitter').first
    Twitter.configure do |config|
      config.consumer_key = 'ABP2ZruFX54U9FpM3HOzNg'
      config.consumer_secret = '7sk9KK4mraEdpv9vvJfgeySnLsukauxOwQeK88WuhA'
      config.oauth_token = provider.token
      config.oauth_token_secret = provider.secret
    end
    @tweeting ||= Twitter::Client.new
  end
  
  def facebook
    provider = self.authentications.where(:provider => 'facebook').first
    if provider
      @facebook ||= Koala::Facebook::API.new(provider.token)
    end
  end
  
  def linkedin
    provider = self.authentications.where(:provider => 'linkedin').first
    client = LinkedIn::Client.new('5bhck1eg3l0i', 'c8IO2JxzHp74OvtQ')
    client.authorize_from_access(provider.token, provider.secret)
    @linkedin = client
  end
  
end
