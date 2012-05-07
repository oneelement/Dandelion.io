require 'active_support/core_ext'

module BackboneHelpers

  module Common
    #Takes an array of params key names which should have _attributes 
    #appended to them (recursively)
    #
    #e.g. calling api_to_nested_attributes(
    #    {a => {a => 1, b => 2}, b => 3}, [a, b])
    #
    # will give {a_attributes => {
    #         a_attributes => 1, b_attributes => 2}, b_attributes => 3}
    def api_to_nested_attributes(params, nested_attribute_keys)

      nested_attribute_keys.each do |k|
        if params.has_key?(k)

          if params[k].is_a?(Array)
            params[k].map do |elem|
              api_to_nested_attributes(elem, nested_attribute_keys)
            end
          else
            params[k] = api_to_nested_attributes(
                            params[k], nested_attribute_keys)
          end

          params[k + '_attributes'] = params[k]
          params.delete(k)
        end
      end

      return params
    end

  end

  module Model
    include BackboneHelpers::Common
  end

  module Controller
    include BackboneHelpers::Common
  end
end
