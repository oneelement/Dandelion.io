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
  has_many :tasks
  has_many :favorites
  embeds_many :authentications
  
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
  field :is_admin, :type => Boolean, :default => false
  field :favorite_ids, :type => Array
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
  end
  
  def as_json(options = nil)
    super((options || {}).merge(include: { favorites: { only: [:favorite_id] } }))
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def authenticated_with?(auth)
    return (authentications.where(provider: auth.to_s).count > 0)
  end
end
