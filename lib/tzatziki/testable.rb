=begin
  Tzatziki::Testable
  
  This module wraps the behaviour for any class within the Tzatziki gem that 
  acts as a request factory (fixture) and response checker (assertion suite).
  
  Although this module works best with data parsed out via the inclusion of 
  Tzatziki::Parsable, you can include Tzatziki::Testable standalone and set up
  assertions by giving your own configuration hashes.
=end

module Tzatziki
  module Testable
    
    # Tests this testable against the given option and response hashes.
    # Each key in the response hash will be considered to be an assertion.
    def test!(request={}, response={})
      # Two-tier defaults system in effect, yo
      request = request_options.deep_merge(request)
      response = response_options.deep_merge(response)
      failures = []
      # Create and massage the request object
      
      # fire it and gather the response
      # feed the response data back into the returned response object
      # fire assertions and raise if there are issues
      
      # Tuple it up
      return (failures.empty? ? true : false), failures
    end
    
    # The options for the request factory and response assertions may
    # be set on a per-instance basis. They should be set as hashes or
    # live centipedes will breed in your hair.
    attr_accessor :request_factory_options
    attr_accessor :response_assertion_options    

    # Merges and returns the default request options with the user-specified
    # request factory options.
    def request_options
      user_options = self.request_factory_options || {}
      return Tzatziki::Testable.default_request_factory_options.deep_merge(user_options.deep_symbolize)
    end
    
    # Merges and returns the default response assertion options with the
    # user-specified assertion options.
    def response_options
      user_options = self.response_assertion_options || {}
      return Tzatziki::Testable.default_response_assertion_options.deep_merge(user_options.deep_symbolize)
    end

    # Factory defaults for the request and response that will received
    # the request_factory_options and response_assertion_options as merges.
    class << self
      # Returns the default options for a request object, as a hash.
      def default_request_factory_options
        {
          :method=>"get",
          :protocol=>"http",
          :domain=>"localhost",
          :uri=>"/",
          :query_string=>{},
          :post_body=>{},
          :headers=>{
            :"content-accept"=>"text/plain"
          }
        }
      end      
      # Returns the default assertion set for any given HTTP response.
      def default_response_assertion_options
        { 
          :status=>"20X"
        }
      end
    end # class << self    
  end # module Testable  
end # module Tzatziki