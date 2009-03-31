module Tzatziki
  
  class Document
    include Documentable
    include Parsable
        
    def inspect
      "<Document: #{@path}>"
    end
  end
  
end