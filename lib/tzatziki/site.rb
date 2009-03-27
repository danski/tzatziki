=begin
  
  Tzatziki::Site
  --------------
  
  The behavioural starting point for a Tzatziki site as a whole.
  This class traverses the given directory structure and instantiates each file appropriately.
  
  Behaviour and code very similar to http://github.com/mojombo/jekyll Jekyll::Site, so thanks TPW!
  The only reason we did not extend that class directly is that we will need to bugger about with
  the processing chain in such a manner as to make extending the class unclean.
  
=end

class Tzatziki::Site
    
    attr_accessor :source, :destination, :config
    attr_accessor :layouts, :apis, :pages, :specifications, :types
    
    # Initialize the site
    #   +source+ is String path to the source directory containing
    #            the proto-site
    #   +dest+ is the String path to the directory where the generated
    #          site should be written
    #
    # Returns <Site>
    def initialize(source, destination)
      self.source = source
      self.destination = destination
      self.layouts = {}
      self.specifications = []
      self.pages = []
      self.apis = []
      self.config = {}
    end
    
    # Do the actual work of processing the site and generating the
    # documentation, as well as outputting the test results.
    #
    # Returns nothing
    def process
      self.read_config
      self.read_layouts
      #self.transform_pages
      #self.write_posts
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
      self.config = data
    end
    
    # Read all the files in <source>/_layouts except backup files
    # (end with "~") into memory for later use.
    #
    # Returns nothing
    def read_layouts
      base = File.join(self.source, "_layouts")
      entries = Dir.entries(base)
      entries = entries.reject { |e| e[-1..-1] == '~' }
      entries = entries.reject { |e| File.directory?(File.join(base, e)) }
      
      entries.each do |f|
        name = f.split(".")[0..-2].join(".")
        self.layouts[name] = Jekyll::Layout.new(base, f)
      end
      return self.layouts
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end
#    
#    # Read all the files in <base>/_posts except backup files (end with "~")
#    # and create a new Post object with each one.
#    #
#    # Returns nothing
#    def read_posts(dir)
#      base = File.join(self.source, dir, '_posts')
#      
#      entries = []
#      Dir.chdir(base) { entries = Dir['**/*'] }
#      entries = entries.reject { |e| e[-1..-1] == '~' }
#      entries = entries.reject { |e| File.directory?(File.join(base, e)) }
#
#      # first pass processes, but does not yet render post content
#      entries.each do |f|
#        if Post.valid?(f)
#          post = Post.new(self.source, dir, f)
#
#          if post.published
#            self.posts << post
#            post.categories.each { |c| self.categories[c] << post }
#          end
#        end
#      end
#      
#      # second pass renders each post now that full site payload is available
#      self.posts.each do |post|
#        post.render(self.layouts, site_payload)
#      end
#      
#      self.posts.sort!
#      self.categories.values.map { |cats| cats.sort! { |a, b| b <=> a} }
#    rescue Errno::ENOENT => e
#      # ignore missing layout dir
#    end
#    
#    # Write each post to <dest>/<year>/<month>/<day>/<slug>
#    #
#    # Returns nothing
#    def write_posts
#      self.posts.each do |post|
#        post.write(self.dest)
#      end
#    end
#    
#    # Copy all regular files from <source> to <dest>/ ignoring
#    # any files/directories that are hidden or backup files (start
#    # with "." or end with "~") or contain site content (start with "_")
#    # unless they are "_posts" directories or web server files such as
#    # '.htaccess'
#    #   The +dir+ String is a relative path used to call this method
#    #            recursively as it descends through directories
#    #
#    # Returns nothing
#    def transform_pages(dir = '')
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
#            transform_pages(File.join(dir, f))
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
#
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
#
#    # The Hash payload containing site-wide data
#    #
#    # Returns {"site" => {"time" => <Time>,
#    #                     "posts" => [<Post>],
#    #                     "categories" => [<Post>],
#    #                     "topics" => [<Post>] }}
#    def site_payload
#      {"site" => {
#        "time" => Time.now, 
#        "posts" => self.posts.sort { |a,b| b <=> a },
#        "categories" => post_attr_hash('categories'),
#        "topics" => post_attr_hash('topics')
#      }}
#    end    
    
end