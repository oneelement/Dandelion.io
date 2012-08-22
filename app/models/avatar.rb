class Avatar
  include Mongoid::Document
  
  validate :image_size_validation, :if => "photo?"
  
  belongs_to :user
  belongs_to :contact
  
  field :name, :type => String
  field :comment, :type => String
  
  mount_uploader :photo, AvatarUploader
  
  private

  def image_size_validation
    errors[:photo] << "should be less than 500KB" if photo.size > 500.kilobytes
  end
end
