module Tzatziki
  
  class Example < Document

    # Examples belong to a document
    attr_accessor :document
    
    def write!
      "Examples are not written to the disk."
    end
    
    def inspect
      "<Example: #{@path}>"
    end
  end
  
end