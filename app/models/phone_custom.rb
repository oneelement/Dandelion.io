class PhoneCustom < Phone
  def self.type_json_name
    'Custom'
  end

  field :custom_name, :type => String
end
