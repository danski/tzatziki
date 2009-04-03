=begin
  Tzatziki Core extensions - Net::HTTPRequest
  -------------------------------------------
  
  Tzatziki extends the Net::HTTPRequest object by allowing you to hand it
  request factory option hashes from the Testable module (usually harvested)
  from documents via the Parsable module.
=end

class Net::HTTPRequest  
  class << self    
    def from_hash(spec, &block)
      # Create and massage the request object
      protocol_klass = module_for_protocol(spec[:protocol])
      method_klass = class_for_method(spec[:method], protocol_klass)
        # Start with the URI
        uri = URI.parse("#{spec[:protocol]}://#{spec[:host]}#{spec[:uri]}")
        # Then the request of correct type with the headers
        # Basic auth
    end
    
    # Returns the wrapping module for a requested protocol.
    # Currently only HTTP is supported, so this method is
    # (for now) pretty redundant. Just refactoring early.
    def module_for_protocol(p)
      case (p.is_a?(Symbol) ? p : p.downcase.to_sym)
      when :https
        Net::HTTPS
      else
        Net::HTTP
      end
    end
    
    # Returns the corresponding request class for a given HTTP method name.
    def class_for_method(m, in_module=Net::HTTP)
      case (m.is_a?(Symbol) ? m : m.downcase.to_sym)
      when :post
        in_module::Post
      when :put
        in_module::Put
      when :head
        in_module::Head
      when :delete
        in_module::Delete
      else
        in_module::Get
      end
    end
    
  end # class << self
  
  module Factory
    class << self
      # Produces a query string from a parameter hash, with a schema like:
      # :parameter_name=>{
      #   :description=>"a text description of the parameter",
      #   :required=>a_boolean,
      #   :values=>{
      #     :a_possible_value=>"a description of this value's meaning"
      #   },
      #   :default=>"a_possible_value",
      #   :example=>"this value will always be used",
      #   :pattern=>"a regular expression used to generate fixture calls"
      # }
      def parameter_hash_to_query_string(parameter_hash)
        parameter_hash.inject([]) do |query, (key, properties)|
          query << "#{key}=#{generate_value_from_parameter_specification(properties)}"
        end.join("&")
      end
    
      def generate_value_from_parameter_specification(properties)
        if example = properties[:example]
          # return example as defacto use case
          return example
        elsif values = properties[:values]
          # use values but error if required is false and default is not specified
          raise RuntimeError, "Multiple-choice attributes must have a :default set if :required is false" unless properties[:required] or properties[:default]
          return properties[:default] || properties[:values].keys.first
        elsif pattern = properties[:pattern]
          # compile and generate pattern using randexp
          return Regexp.compile(pattern).gen
        elsif default = properties[:default]
          # fall back to default
          return default
        else
          # fall back to FAIL
          "FAIL"
        end
      end
    end # class << self
  end # module Factory  
end # class Net::HTTPRequest