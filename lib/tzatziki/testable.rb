module Tzatziki
  
  module Testable
    
    class << self
      # Singleton methods
      
      # Returns the default options for a request object, as a hash.
      def request_defaults
        {
          :domain=>"http://localhost",
          :uri=>"/",
          :query_string=>{},
          :post_body=>{},
          :headers=>{
            :"content-accept"=>"application/xml"
          }
        }
      end
      
      # Returns the default assertion set for any given HTTP response.
      def response_defaults
        { 
          :status=>200
        }
      end
    end
    
  end
  
end