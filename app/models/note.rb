class Note
  include Mongoid::Document

  embedded_in :contact

  field :text, :type => String
end
