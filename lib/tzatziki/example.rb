module Tzatziki
  
  class Example < Document

    # Examples belong to a document
    attr_accessor :document
    
    # The data inherits from the parent document
    def data
      (document)? document.data.deep_merge(super) : super
    end
    
    def write!
      "Examples are not written to the disk."
    end
    
    def inspect
      "<Example: #{@path}>"
    end
  end
  
end