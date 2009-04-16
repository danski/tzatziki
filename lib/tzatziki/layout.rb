module Tzatziki
  class Layout
    include Documentable
    include Parsable
    
    def initialize(*args)
      super
      parse!
    end
    
    def write!(*args)
      return nil
    end
    
  end #class Layout
end #module Tzatziki