module Tzatziki
  
  class Document
    include Documentable
    include Parsable
    include Testable
    
    def process!
      parse!
      preflight!
      # set the request factory options
      # test this document
      # test the examples
      write!
    end
    
    def inspect
      "<Document: #{@path}>"
    end
  end
  
end