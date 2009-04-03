module Tzatziki
  
  class Document
    include Documentable
    include Parsable
    include Testable

    def initialize(*args)
      super
      parse!
      self.data = self.api.inject_specifications(self.data)
      self.data = self.api.inject_types(self.data)
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