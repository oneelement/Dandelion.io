class Note
  include Mongoid::Document

  belongs_to :contact
  belongs_to :group

  field :text, :type => String
end
