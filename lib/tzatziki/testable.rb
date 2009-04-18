=begin
  Tzatziki::Testable
  
  This module wraps the behaviour for any class within the Tzatziki gem that 
  acts as a request factory (fixture) and response checker (assertion suite).
  
  Although this module works best with data parsed out via the inclusion of 
  Tzatziki::Parsable, you can include Tzatziki::Testable standalone and set up
  assertions by giving your own configuration hashes.
=end

require 'net/http'

module Tzatziki
  module Testable
    
    attr_accessor :request
    attr_accessor :response
    attr_accessor :tested
    def tested?; tested; end
    
    # Tests this testable against the given option and response hashes.
    # Each key in the response hash will be considered to be an assertion.
    def test!(request={}, response={}, variable_payload={})
      # Two-tier defaults system in effect, yo
      request_spec = request_options.deep_merge(request)
      response_spec = response_options.deep_merge(response)
      failures = []
      
      # fire it and gather the response (::from_hash is defined in core_ext/http_request)
      self.response = Net::HTTPRequest.from_hash(request_spec) do |http, req|
        http.request(req)
      end
      self.tested = true
      return self.response.compare!(response_spec, variable_payload)
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
    
    # Extends the payload by including the response data. The response data will only be
    # included if the document has been tested.
    def payload
      if tested?
        resp = self.response.to_payload_hash 
        super.merge({:response=>resp})
      else
        super
      end
    end

    # Factory defaults for the request and response that will received
    # the request_factory_options and response_assertion_options as merges.
    class << self
      # Returns the default options for a request object, as a hash.
      def default_request_factory_options
        {
          :method=>"get",
          :protocol=>"http",
          :host=>"localhost",
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