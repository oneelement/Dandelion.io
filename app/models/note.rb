class Note
  include Mongoid::Document
  include Mongoid::Paranoia

  belongs_to :contact
  belongs_to :group

  field :text, :type => String
end
