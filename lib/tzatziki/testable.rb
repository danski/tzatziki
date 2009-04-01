module Tzatziki
  
  module Testable
    
    class << self
      # Singleton methods
      
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
      
      def response_defaults
        { 
          :status=>200
        }
      end
    end
    
  end
  
end