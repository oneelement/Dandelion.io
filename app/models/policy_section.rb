class PolicySection
  include Mongoid::Document

  belongs_to :section

  embedded_in :policy, :inverse_of => :policy_sections
  embeds_many :question_answers
  accepts_nested_attributes_for :question_answers, :allow_destroy => true
end
