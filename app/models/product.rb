class Product
  include Mongoid::Document

  has_many :versions, :class_name => 'ProductVersion'

  def development_versions
    versions.development
  end

  def live_versions
    versions.live
  end
end

#Not using Mongoid::Versioning as we want to be able to do a
#few slightly more bespoke things (current live version, linking
#a policy to a specific version etc). The version number shouldnt
#increase each time we save, but only when the version is 'published'
class ProductVersion
  include Mongoid::Document
  #Timestamps are used to help with the product builder interface
  include Mongoid::Timestamps

  belongs_to :product

  scope :live, excludes(:live_date => nil)
  scope :development, where(:live_date => nil)

  has_many :policies

  embeds_many :product_sections
  accepts_nested_attributes_for :product_sections, :allow_destroy => true

  #Product name stored on per-version basis in case product is renamed
  field :product_name, :type => String
  #Used in the builder interface to help the user figure out the changes
  #they are making if they save and come back
  field :version_description, :type => String
  #Live date is used to determine what the latest 'live' version is
  field :live_date, :type => DateTime

end


class ProductSection
  include Mongoid::Document

  belongs_to :section, :autosave => true
  embeds_many :product_sections
  embeds_many :product_questions
  accepts_nested_attributes_for :sections, :allow_destroy => false
  accepts_nested_attributes_for :product_sections, :product_questions, :allow_destroy => true
end

class ProductQuestion
  include Mongoid::Document

  belongs_to :question, :autosave => true
  embeds_many :product_question_possible_answers
  accepts_nested_attributes_for :questions, :product_question_possible_answers, :allow_destroy => false
end

class ProductQuestionPossibleAnswer
  include Mongoid::Document

  belongs_to :question_answer, :autosave => true
  accepts_nested_attributes_for :question_answers, :allow_destroy => false
end
