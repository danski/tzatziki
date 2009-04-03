module Tzatziki
  
  class Document
    include Documentable
    include Parsable
    include Testable

    def initialize(*args)
      super
      parse!
    end
    
    def process!
      # set the request factory options
      # test this document
      # test the examples
      # write the file
      write!
    end
    
    def inspect
      "<Document: #{@path}>"
    end
  end
  
end