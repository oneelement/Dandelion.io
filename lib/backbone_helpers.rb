module BackboneHelpers
  module Controller

    #Takes an array of params key names which should have _attributes appended to them (recursively)
    #e.g. calling params_to_nested_attributes([a, b], {a => {a => 1, b => 2}, b => 3}) will give
    #{a_attributes => {a_attributes => 1, b_attributes => 2}, b_attributes => 3}
    def params_to_nested_attributes(attributes_to_map, params)

      attributes_to_map.each do |k|
        if params.has_key?(k)

          if params[k].is_a?(Array)
            out = params[k].map do |elem|
              params_to_nested_attributes(attributes_to_map, elem)
            end
          else
            params[k] = params_to_nested_attributes(attributes_to_map, params[k])
          end

          params[k + '_attributes'] = params[k]
          params.delete(k)
        end
      end

      return params

    end

  end
end
