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
        uri = URI.parse("#{spec[:protocol]}://#{spec[:domain]}#{spec[:uri]}")
        # Then the request of correct type with the headers
        # Basic auth
    end
    
    # Produces a query string from a parameter hash, with a schema like:
    # :parameter_name=>{
    #   :description=>"a text description of the parameter",
    #   :required=>a_boolean,
    #   :values=>{
    #     :a_possible_value=>"a description of this value's meaning"
    #   },
    #   :default=>"a_possible_value"
    # }
    def parameter_hash_to_query_string
      
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
end # class Net::HTTPRequest