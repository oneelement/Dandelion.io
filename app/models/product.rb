class Product
  include Mongoid::Document

  #This will eventually contain details about who created the product, availability? etc

  has_many :versions, :class_name => 'ProductVersion', :autosave => true
  accepts_nested_attributes_for :versions

  def development_versions
    versions.development
  end

  def live_versions
    versions.live
  end

  def current_live_version
    versions.live.first
  end

  def most_recent_development_version
    versions.development.first
  end

  def name
    if current_live_version
      return current_live_version.product_name
    elsif most_recent_development_version
      return most_recent_development_version.product_name
    else
      return 'Unknown'
    end
  end

end
