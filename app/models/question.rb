class Question
  include Mongoid::Document

  belongs_to :section
  belongs_to :question_type

  field :name, :type => String
end
