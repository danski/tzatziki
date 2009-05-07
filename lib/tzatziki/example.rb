module Tzatziki
  
  class Example < Document

    def initialize(*args)
      super
      parse!(self.raw)
      self.data = self.api.inject_specifications(self.data)
      self.data = self.api.inject_types(self.data)
      self.data = self.api.inject_configuration(self.data)
    end
    
    def write!
      "Examples are not written to the disk."
    end
    
    def inspect
      "<Example: #{@path}>"
    end
  end
  
end