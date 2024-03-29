#Not using Mongoid::Versioning as we want to be able to do a
#few slightly more bespoke things (current live version, linking
#a policy to a specific version etc). The version number shouldnt
#increase each time we save, but only when the version is 'published'
class ProductVersion
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :product

  scope :live, excludes(:live_date => nil).order_by(:live_date => :desc)
  scope :development, where(:live_date => nil).order_by(:live_date => :desc)

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

  acts_as_api

  api_accessible :product_version do |t|
    t.add :id
    t.add :product_name
    t.add :version_description
    t.add :live_date
    t.add :product_sections, :template => :product_section
  end

  def is_live
    if live_date.nil?
      return false
    else
      return true
    end
  end

  def status
    if is_live
      return 'Live'
    else
      return 'Development'
    end
  end
end


class ProductSection
  include Mongoid::Document

  belongs_to :section

  embedded_in :product_version, :inverse_of => :product_sections
  embedded_in :product_section, :inverse_of => :product_sections

  embeds_many :product_sections
  embeds_many :product_questions
  accepts_nested_attributes_for :product_sections, :product_questions, :allow_destroy => true

  field :mandatory, :type => Boolean, :default => false
  field :repeats, :type => Boolean, :default => false
  field :repeat_max_instances, :type => Integer

  acts_as_api

  api_accessible :product_section do |t|
    t.add :id
    t.add :section, :template => :section
    t.add :mandatory
    t.add :repeats
    t.add :repeat_max_instances
    t.add :product_sections
    t.add :product_questions, :template => :product_question
  end

end

class ProductQuestion
  include Mongoid::Document

  belongs_to :question, :autosave => true
  embeds_many :product_question_possible_answers

  acts_as_api

  api_accessible :product_question do |t|
    t.add :id
    t.add :question, :template => :question
  end
end

class ProductQuestionPossibleAnswer
  include Mongoid::Document

  belongs_to :question_answer, :autosave => true
end
