class Question
  include Mongoid::Document

  embedded_in :section
  referenced_in :question_type

  field :name, :type => String
end
