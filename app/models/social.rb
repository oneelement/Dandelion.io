class Social
  include Mongoid::Document
  
  embedded_in :contact
  
  field :social_id, :type => String

end

class Facebook < Social
end

class Linkedin < Social
end

class Twitter < Social
end
