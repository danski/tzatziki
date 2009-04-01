=begin
  
  Tzatziki::Site
  --------------
  
  The bootstrap class for a Tzatziki site as a whole.
  
  While Tzatziki::API is the main documentation/recursion class, Tzatziki::Site adds
  site-wide behaviours such as layouts to the mix.
  
  Behaviour and code very similar to http://github.com/mojombo/jekyll Jekyll::Site, so thanks TPW!
  The only reason we did not extend that class directly is that we will need to bugger about with
  the processing chain in such a manner as to make extending the class unclean, and we want to add
  recursion which means we'll need to break the methods out into modules.
  
=end
module Tzatziki
  class Site < API
    
      attr_accessor :layouts
    
      # Initialize the site
      #   +source+ is String path to the source directory containing
      #            the proto-site
      #   +dest+ is the String path to the directory where the generated
      #          site should be written
      #
      # Returns <Site>
      def initialize(source, destination)
        super(source, destination)
        self.layouts = {}
      end
    
      # Do the actual work of processing the site and generating the
      # documentation, as well as outputting the test results.
      #
      # Returns nothing
      def process(recurse=false)
        #self.read_layouts
        super
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
end