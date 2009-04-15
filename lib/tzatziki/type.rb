module Tzatziki
  class Type
    include Documentable
    include Parsable
  
    def initialize(*args)
      super
      parse!(self.raw, :layout=>"type")
      self.data = self.api.inject_configuration(self.data)
    end
  end # class Type
end # module Tzatziki