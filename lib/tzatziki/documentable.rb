module Tzatziki
  
  # Documentable is a module wrapping the behaviour of all Tzatziki objects that will be converted into
  # documents in the file system.
  
  module Documentable
    
    # The Tzatziki::API instance to which this documentable belongs.
    attr_accessor :api
    # The raw, unprocessed document
    attr_accessor :raw
    
    # Initializes the object given:
    # path_or_document: A string which can be the path to a file (which will be read), or
    #                   the document to be dealt with itself.
    # api:              An instance of Jekyll::API, to which this document will belong.
    def initialize(path_or_document, api=nil)
      self.api = api
      if File.file?(path_or_document)
        read(path_or_document)
      else
        self.raw = path_or_document
      end
    end
    
    # Reads the source file into an instance variable called 'ra'.
    # Returns nothing.    
    def read(path_to_source_file)
      f = File.open(path_to_source_file)
      self.raw = f.read
    end
    
  end
end