module Tzatziki
  class Type
    include Documentable
    include Parsable
  
    def initialize(*args)
      super
      parse!
    end
  end # class Type
end # module Tzatziki