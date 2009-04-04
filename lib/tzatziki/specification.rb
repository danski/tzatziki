module Tzatziki
  
  class Specification
    include Documentable
    include Parsable
  
    def initialize(*args)
      super
      parse!
      self.data = self.api.inject_types(self.data)
      self.data = self.api.inject_configuration(self.data)
    end
  end # class Specification  
end # module Tzatziki