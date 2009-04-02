=begin

  Tzatziki::API
  -------------
  
  The main collection class for Tzatziki. A Tzatziki::API instance is very much like a self-contained
  Tzatziki::Site (which behaves in turn like a Jekyll::Site), but the Tzatziki::API class allows recursion.
  
  The special folders used by Tzatziki, such as _specifications and _types, may be nested within child APIs
  where they will only be available to APIs that level or lower in the tree.
  
  Including a specification or type lower down the tree with the same name as one higher up the tree will
  completely replace the higher-up version for all documents this level or lower, in a predictable display of 
  override behaviour. Developers should note that replacement specs/types are not merged with their 
  parent counterparts but rather completely replace them at the point of insertion and below.

=end

module Tzatziki
  class API
    
    # The source and destination folders for this API
    attr_accessor :source, :destination
    # Each API may have one parent API instance, used for inheritance of config and other variables,
    # and 0..n child API instances which will inherit from this one. Each API also belongs to an
    # instance of Tzatziki::Site.
    attr_accessor :site, :parent, :children
    # Each API may have documents, specifications and types.
    attr_accessor :config, :documents, :specifications, :types
    # Specs and types specific to this level of recursion are made available here.
    attr_accessor :local_specifications, :local_types
    # Job state
    attr_accessor :processed
    
    # Initializes and returns the API object.
    #   +source+ is the path to the API's source folder.
    #   +destination+ is the path in which the API documentation is being generated.
    #   +parent+ (optional) is the Tzatziki::API instance that this API inherits from.
    # 
    # Returns <API>
    def initialize(source, destination, parent=nil)
      # Set properties
      self.source = source
      self.destination = destination
      # Blanks that will get populated by recursive descent through the file system.
      self.documents = []
      self.children = []
      self.local_specifications = {}
      self.local_types = {}
      # Blanks that will get duped from parent and then merged with local results
      # when we descend from this point.    
      self.specifications   = (parent)? parent.specifications.dup : {}
      self.types            = (parent)? parent.types.dup : {}
      self.config           = (parent)? parent.config.dup : {}
      # Register parent
      if parent
        self.parent = parent
        parent.children << self unless parent.children.include?(self)
        # Traverse upwards and find root site
        p = parent
        while p and !p.is_a?(Tzatziki::Site) do
          p = parent.parent
        end
        self.site = p
      end
      process
    end
    
    # Do the actual work of processing the site and generating the
    # documentation, as well as outputting the test results.
    #
    # Returns nothing
    def process(recurse=true)
      unless self.processed      
        process!(recurse)
      end
      self.processed = true
    end
    def process!(recurse=true)
      self.read_config
      self.read_specifications
      self.read_types
      self.read_documents
      self.read_children      
      self.children.each { |c| c.process } if recurse
    end
  
    # Read the config file into a hash ready for inclusion in the site payload.
    # The config file is intended to include non-example data such as the API
    # key for the account against which you'll be running the tests.
    # The keys in the config file are completely arbitrary and can be changed from implementation
    # to implementation.
    #
    # Example of using the config file: Your API uses OAuth. You've registered Tzatziki in your
    # system as an OAuth client. The API key and secret should be in the config file. The user
    # cloud go through the OAuth process to authorise these tests against their account, and include
    # their token key and secret in the config file as well. Now they've got the tests set up to run
    # against their account, if they so wish, without disrupting service to other users.
    # 
    # Returns the resulting config hash. If the config file is not present, the hash will be empty.
    # If the file does not parse, an error will be raised.
    def read_config
      config_file = File.join(self.source, "config.yml")
      begin
        data = YAML.load(File.read(config_file)) 
      rescue Errno::ENOENT => e
        data = {}
      end
      self.config = self.config.deep_merge(data)
    end
    
    # Reads and instantiates any specifications in the _specifications directory below self.source,
    # if such a folder exists. Otherwise the specifications hash will be left untouched from the parent.
    def read_specifications
      self.local_specifications = read_documentables_from_directory("_specifications", Tzatziki::Specification)
      self.specifications.merge!(self.local_specifications)
    end
    
    # Reads and instantiates any types in the _types directory below self.source,
    # if such a folder exists. Otherwise the types hash will be left untouched from the parent.
    def read_types
      self.local_types = read_documentables_from_directory("_types", Tzatziki::Type)
      self.types.merge!(self.local_types)
    end
    
    # Read all the flat text files in self.source and create a new Document instance for each.
    def read_documents
      self.documents = read_documentables_from_directory(self.source, Tzatziki::Document).values
    end
    
    # Read all the directories under self.source except for those:
    #   beginning with _ or .
    #   ending with ~ or .examples
    # and create new Tzatziki::API instances for them.
    def read_children
      entries = Dir.entries(self.source)
      directories = entries.select { |e| File.directory?(File.join(self.source, e)) }
      directories = directories.reject { |d| d[0..0]=~/\.|_/ or d=~/\.examples$/ or d[-1..-1]=="~" }
      directories.each do |dir|
        api = Tzatziki::API.new(File.join(self.source, dir), self.destination, self)
      end
    end
    
    # Comparison with another Tzatziki::Site or Tzatziki::API instance.
    # Returns <true> if the source directories of both objects match.
    def ==(other)
      self.source == other.source
    end
    
    # Returns the relative path components off the site root.
    # If this instance of Tzatziki::API is in a subfolder named "bar"
    # within another subfolder called "foo" off the site root "~user/taz_site",
    # then site path_offset_components will be "foo/bar"
    def path_offset
      self.source.gsub /#{self.site.source}\//, ""
    end
    
    # Marshalls the API into a hash ready for inclusion in templates.
    # Returns the resulting hash object.
    def to_hash(include_children=true)
      {
        :config=>config,
        :parent=>(parent ? parent.to_hash(false) : {}),
        :children=>(include_children ? children.collect{|c| c.to_hash} : nil)
      }
    end
    
    # Takes a hash which may reference specifications from this API
    # (or from its parents) and expands it to fill in all the detail. If specification
    # is referenced that does not exist at this point in the tree, an exception 
    # will be raised. Otherwise, the resulting merged hash will be returned.
    #
    # Looks for entries in a hash like this:
    # {:foo=>:bar, :bar=>{ :car=>:daz }, :specifications=>{:myspec=>true}}
    # The :specifications key will be found (even if nested in a child hash), and the 
    # hash containing this key will be deep_merged against the data hash from the referenced
    # specifications.
    #
    # Additional note: this method runs recursively against any hashes used as values
    # within the given argument.
    def inject_specifications(specifiable={})
      h = specifiable.dup.deep_symbolize
      # Locate specification keys and create the merged spec hash
      spec_list = h[:specifications] || {}
      spec_opts = spec_list.inject({}) do |memo, (key, value)|
        memo.deep_merge(specifications[key.to_s].data.deep_symbolize) if value
      end
      # Recurse over each child hash
      h = h.inject({}) do |memo, (key, value)|
        memo.merge(key => (value.is_a?(Hash)? self.inject_specifications(value) : value))
      end
      spec_opts.deep_merge(h)
    end
    
    # Takes a hash which may reference types from this API
    # (or from its parents) and expands it to fill in all the detail. If a
    # type is referenced that does not exist at this point in the tree, an exception 
    # will be raised. Otherwise, the resulting merged hash will be returned.
    # 
    # Looks for entries in a hash like this:
    # {:foo=>{:type=>:mytype, :this_attribute=>:preserved}} 
    # The data hash from the type :mytype will be have merge called against it
    # with the hash containing the :type key as an argument, and the resulting
    # merge will replace the value of key :foo in the returned hash.
    #
    # Additional note: this method runs recursively against any hashes used as values
    # within the given argument.
    def inject_types(specifiable={})
      h = specifiable.dup.deep_symbolize
      # Locate type keys and create the merged spec hash
      type_opts = if type = h[:type]
                    types[type.to_s].data rescue raise(Tzatziki::TypeNotFound, "Type #{type.inspect} not available for api #{to_hash.inspect}")
                  else
                    {}
                  end
      # Recurse over each child hash
      h = h.inject({}) do |memo, (key, value)|
        memo.merge(key => (value.is_a?(Hash)? self.inject_types(value) : value))
      end
      type_opts.deep_merge(h)
    end
    
    private
    def read_documentables_from_directory(folder, transformable_klass)
      begin
        path = (folder==self.source)? folder : File.join(self.source, folder)
        entries = Dir.entries(path)
        files = entries.reject { |e| File.directory?(File.join(path, e)) }
        files = files.reject { |e| e[0..0]=~/\.|_/ or e[-1..-1]=="~" or e.match(/\.(yaml|yml)/) }
        documentables = {}
        files.each do |f|
          documentables[f.split(".").first] = transformable_klass.new(File.join(path, f), self)
        end
        return documentables
      rescue Errno::ENOENT => e
        # Ignore missing specifications
        return {}
      end
    end
        
    

#    # Copy all regular files from <source> to <dest>/ ignoring
#    # any files/directories that are hidden or backup files (start
#    # with "." or end with "~") or contain site content (start with "_")
#    # unless they are "_posts" directories or web server files such as
#    # '.htaccess'
#    #   The +dir+ String is a relative path used to call this method
#    #            recursively as it descends through directories
#    #
#    # Returns nothing
#    def transform_documents(dir = '')
#      base = File.join(self.source, dir)
#      entries = Dir.entries(base)
#      entries = entries.reject { |e| e[-1..-1] == '~' }
#      entries = entries.reject do |e|
#        (e != '_posts') and ['.', '_'].include?(e[0..0]) unless ['.htaccess'].include?(e)
#      end
#      directories = entries.select { |e| File.directory?(File.join(base, e)) }
#      files = entries.reject { |e| File.directory?(File.join(base, e)) }
#
#      # we need to make sure to process _posts *first* otherwise they 
#      # might not be available yet to other templates as {{ site.posts }}
#      if entries.include?('_posts')
#        entries.delete('_posts')
#        read_posts(dir)
#      end
#      [directories, files].each do |entries|
#        entries.each do |f|
#          if File.directory?(File.join(base, f))
#            next if self.dest.sub(/\/$/, '') == File.join(base, f)
#            transform_documents(File.join(dir, f))
#          else
#            first3 = File.open(File.join(self.source, dir, f)) { |fd| fd.read(3) }
#        
#            if first3 == "---"
#              # file appears to have a YAML header so process it as a page
#              page = Page.new(self.source, dir, f)
#              page.render(self.layouts, site_payload)
#              page.write(self.dest)
#            else
#              # otherwise copy the file without transforming it
#              FileUtils.mkdir_p(File.join(self.dest, dir))
#              FileUtils.cp(File.join(self.source, dir, f), File.join(self.dest, dir, f))
#            end
#          end
#        end
#      end
#    end

    
#    # Write each post to <dest>/<year>/<month>/<day>/<slug>
#    #
#    # Returns nothing
#    def write_posts
#      self.posts.each do |post|
#        post.write(self.dest)
#      end
#    end

#    # Constructs a hash map of Posts indexed by the specified Post attribute
#    #
#    # Returns {post_attr => [<Post>]}
#    def post_attr_hash(post_attr)
#      # Build a hash map based on the specified post attribute ( post attr => array of posts )
#      # then sort each array in reverse order
#      hash = Hash.new { |hash, key| hash[key] = Array.new }
#      self.posts.each { |p| p.send(post_attr.to_sym).each { |t| hash[t] << p } }
#      hash.values.map { |sortme| sortme.sort! { |a, b| b <=> a} }
#      return hash
#    end
    
  end
end