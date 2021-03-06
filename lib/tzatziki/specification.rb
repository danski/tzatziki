module Tzatziki
  
  class Specification
    include Documentable
    include Parsable
  
    def initialize(*args)
      super
      parse!(self.raw, :layout=>"document")
      self.data = self.api.inject_types(self.data)
      self.data = self.api.inject_configuration(self.data)
    end
    
    def write_basename
      "specification.#{super}"
    end
    
  end # class Specification  
end # module Tzatziki