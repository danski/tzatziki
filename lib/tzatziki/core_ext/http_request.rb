=begin
  Tzatziki Core extensions - Net::HTTPRequest
  -------------------------------------------
  
  Tzatziki extends the Net::HTTPRequest object by allowing you to hand it
  request factory option hashes from the Testable module (usually harvested)
  from documents via the Parsable module.
=end

class Net::HTTPRequest  
  class << self
    
    # Creates and returns a Net:HTTPRequest object of the appropriate type from
    # a Tzatziki specification hash object. 
    # If no block is given, returns the created Net:HTTPRequest object.
    # May optionally be given a block like so:
    #
    # response = Net::HTTPRequest.from_hash(specification) do |http, request|
    #   http.start(request)
    # end
    #
    # In cases where the block is given, the request will be automatically closed
    # at the end of the block scope.
    def from_hash(spec, &block)
      # Create and massage the request object
      protocol_klass = module_for_protocol(spec[:protocol])
      method_klass = class_for_method(spec[:method], protocol_klass)
        # Start with the URI
        uri = Factory.specification_hash_to_uri(spec)
        # Then create the request of correct type and combine the query
        request = method_klass.new(uri.path + ("?#{uri.query}" if uri.query))
        # Set the form data if given (this will set the method to POST)
        request.set_form_data(Factory.parameter_hash_to_fixture_hash(spec[:form_data])) if spec[:form_data]
        # Headers
        if spec[:headers].is_a?(Hash)
          spec[:headers].each { |key, value| request[key.to_s] = value }
        end
        
        if block_given?        
          response =  Net::HTTP.start(uri.host, uri.port) do |http|
                        block.call(http, request)
                      end
          return response
        end
        return request
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
      
      def specification_hash_to_uri(spec)
        uri = URI.parse("")
        uri.scheme = spec[:protocol]
        uri.host = spec[:host]
        uri.port = spec[:port] if spec[:port]
        uri.path = spec[:uri]
        uri.fragment = spec[:fragment] if spec[:fragment]
        uri.query = parameter_hash_to_query_string(spec[:query_string]) if spec[:query_string]
        uri
      end
      
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
      
      # Much like parameter_hash_to_query_string, this method takes a parameter
      # specification hash and generates a fixture from it with dm-sweatshop-style
      # behaviour. This function returns the query as a hash suitable for
      # handing off to ruby's internal HTTPRequest object.
      def parameter_hash_to_fixture_hash(parameter_hash)
        parameter_hash.inject({}) do |fixture, (key, properties)|
          fixture[key] = generate_value_from_parameter_specification(properties)
        end
      end
    
      def generate_value_from_parameter_specification(properties, escape=true)
        val =   if example = properties[:example]
                  # return example as defacto use case
                  example
                elsif values = properties[:values]
                  # use values but error if required is false and default is not specified
                  raise RuntimeError, "Multiple-choice attributes must have a :default set if :required is false" unless properties[:required] or properties[:default]
                  properties[:default] || properties[:values].keys.first
                elsif pattern = properties[:pattern]
                  # compile and generate pattern using randexp
                  Regexp.compile(pattern).gen
                elsif default = properties[:default]
                  # fall back to default
                  default
                else
                  # fall back to FAIL
                  "FAIL"
                end
          return (escape)? URI.escape(val) : val
      end
    end # class << self
  end # module Factory  
end # class Net::HTTPRequest