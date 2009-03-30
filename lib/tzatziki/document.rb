module Tzatziki
  
  class Document
    include Jekyll::Convertible
    
    def initialize(path, api=nil)
      @path = path; @api = api
    end
    
    def inspect
      "<Document: #{@path}>"
    end
  end
  
end