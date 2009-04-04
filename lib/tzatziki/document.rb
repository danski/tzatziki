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
      self.data = self.api.inject_configuration(self.data)
    end
    
    def test!
      super(self.data[:request], self.data[:response])
    end
    
    # Determines if tests should be run against this particular document
    # based on the presence of a request fixture in the doc.
    def testable?
      true if self.data[:request]
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