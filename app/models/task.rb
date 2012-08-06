class Task
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  
  belongs_to :user
  
  field :title, :type => String
  field :content, :type => String
  field :complete, :type => Boolean
  
 
  def as_json(options = nil)
    super((options || {}).merge(include: { user: { only: [:first_name, :last_name] } }))
  end  
end
