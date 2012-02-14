#This is a temporary model used for mocking out the rating engine.
#DO NOT ADD MUCH TO THIS FOR THE TIME BEING
#

require 'date'

class Quote
    include Mongoid::Document

    @@rate = 0.03

    embeds_one :risk
    accepts_nested_attributes_for :risk
    
    field :premium, :type => Float
    field :expiry_date, :type => DateTime

    before_create :calculate_premium
    before_create :set_expiry_date

    def calculate_premium
        self.premium = self.risk.sum_insured * @@rate
    end

    def set_expiry_date
        self.expiry_date = DateTime.now.next_month
    end


end

#The risk associated with the quote
class Risk
    include Mongoid::Document

    embedded_in :quote, :inverse_of => :risk
    field :sum_insured, :type => Integer
end
