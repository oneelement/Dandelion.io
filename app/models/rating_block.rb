class RatingBlock
  include Mongoid::Document

  #Can source data from several sections
  has_and_belongs_to_many :sections, inverse_of: nil

  #Can delegate rating to sub rating units
  has_many :sub_blocks, class_name: 'RatingBlock'

  #Actual steps that peform calculations
  embeds_many :rating_steps
end

#An actual calculation performed as part of a whole rating algorithm
class RatingStep
  include Mongoid::Document

  #A meaningful name which may be given to the (result of the) step, e.g. 'Contents base premium'
  field :name

  #The step as input in the rating builder by the user
  field :step_raw
  
  #The step after parsing as to be used by the rating runner
  field :step_parsed
  
end
