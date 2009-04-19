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
        super
      end
    
      def write_path
        self.destination
      end
      
      def document!(*args)
        # clear path
        if self.destination == "/" or File.expand_path(self.destination) == File.expand_path("~")
          raise RuntimeError, "You're about to do something very stupid and dangerous."
        else
          FileUtils.rm_r File.expand_path(self.destination)
          FileUtils.mkdir_p File.expand_path(self.destination)
        end
        # run super
        super
      end  
    
  end
end