module Tzatziki
  
  class Specification
    include Documentable
    include Parsable
  
    def initialize(*args)
      super
      parse!
    end
  end # class Specification  
end # module Tzatziki