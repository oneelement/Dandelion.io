class Question
  include Mongoid::Document

  embedded_in :section

  field :name, :type => String
end
