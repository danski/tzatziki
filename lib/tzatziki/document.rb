module Tzatziki
  
  class Document
    include Documentable
    include Parsable
    include Testable

    attr_accessor :examples

    def initialize(*args)
      super
      @examples = {}
      parse!(self.raw, :layout=>"document")
      self.data = self.api.inject_specifications(self.data)
      self.data = self.api.inject_types(self.data)
      self.data = self.api.inject_configuration(self.data)
    end
    
    # Sets the examples as a hash such as would be outputted by the
    # read_documentables_from_directory method on Tz::API.
    def examples=(examples_hash)
      @examples = examples_hash
    end
    
    def test!(*args)
      super(self.data[:request], self.data[:response])
    end
    
    def payload
      super.merge({
        :examples=>examples.collect {|name, doc| doc.to_hash }
      })
    end
    
    # Determines if tests should be run against this particular document
    # based on the presence of a request fixture in the doc.
    def testable?
      true if self.data[:request]
    end
    
    def inspect
      "<Document: #{@path}>"
    end
  end
  
end