require 'digest/md5'

module Tzatziki
  
  # Documentable is a module wrapping the behaviour of all Tzatziki objects that will be converted into
  # documents in the file system.
  
  module Documentable
    
    # The Tzatziki::API instance to which this documentable belongs.
    attr_accessor :api
    # The original filename
    attr_accessor :file_basename
    # The raw, unprocessed document
    attr_accessor :raw

    # Initializes the object given:
    # path_or_document: A string which can be the path to a file (which will be read), or
    #                   the document to be dealt with itself.
    # api:              An instance of Jekyll::API, to which this document will belong.
    def initialize(path_or_document, api=nil, basename=nil)
      self.api = api
      if File.file?(path_or_document)
        self.file_basename = File.basename(path_or_document)
        read(path_or_document)
      else
        self.raw = path_or_document
        self.file_basename = basename
      end
    end
    
    # Reads the source file into an instance variable called 'ra'.
    # Returns nothing.    
    def read(path_to_source_file)
      f = File.open(path_to_source_file)
      self.raw = f.read
    end
    
    # Renders the documentable via Liquid to a string, recursing to any 
    # specified layouts.
    # +raw_source+ is the string to render, while 
    # +_payload+ is a Mash of options to pass to the templates.
    def render(_payload={}, do_layout=true)
      s,p = self.raw, template_payload.merge(_payload)
      s = Liquid::Template.parse(s).render(Mash.new(p), Tzatziki::Filters)
      s = self.transform(s)
      
      if (layout_name = p[:layout]) and (do_layout)
        p.delete(:layout)
        s = self.api.layouts[layout_name].render(p.merge(:content=>s)) rescue s
      end
      
      return s
    end
    
    def transform(content=self.raw)
      case self.file_basename
      when /\.textile/
        RedCloth.new(content).to_html
      when /\.(mdown|markdown)/
        Maruku.new(content).to_html
      else
        content
      end
    end
    
    def write_basename
      if file_basename
        ext = File.extname(file_basename)
        file_basename[0..(file_basename.length-ext.length-1)]
      else
        @write_basename ||= Digest::MD5.hexdigest(self.raw)
      end
    end
    def write_filename; "#{write_basename}.html"; end
    
    def write_path
      File.join(
        self.api.write_path,
        self.write_filename
      )
    end
    
    def uri
      write_path.gsub(self.api.destination, "")
    end
    
    def write!(content=self.render)
      FileUtils.mkdir_p(File.dirname(write_path))
      out = File.open(write_path, "w+")
      out.rewind
      out.write(content)
      out.close
    end
    
    # Returns a hash representing the global template payload for this 
    # instance. The global template payload includes the user config for
    # this API, the API document tree and other utilities. It is made available
    # to any request fixtures that use liquid syntax, and is also included in the
    # wider hash used to render this document as an HTML file.
    def template_payload
      { 
        :document => to_hash,
        :site => (Tzatziki::Site.singleton.to_hash rescue {}),
        :api => api.to_hash
      }.merge(self.payload)
    end
    
    def to_hash
      {
        :uri=>uri
      }.merge(self.payload)
    end
    
    # Should be overridden to return a hash for the template implementation of the including class.
    def payload
      raise InterfaceNotProvided
    end
    
    class << self
      def file_extensions
        %w(.html .textile .markdown .mdown)
      end
    end
    
  end
end