class AddressCustom < Address
  field :custom_name, :type => String
  def self.type_json_name
    'Custom'
  end
end
