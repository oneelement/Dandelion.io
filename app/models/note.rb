class Note
  include Mongoid::Document

  embedded_in :contact
  embedded_in :group

  field :text, :type => String
end
