module Tzatziki
  
  class Document
    include Documentable
    include Parsable
    
    def process!
      parse!
      preflight!
      test!
      write!
    end
    
    def inspect
      "<Document: #{@path}>"
    end
  end
  
end