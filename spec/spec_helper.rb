require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), *%w[.. lib tzatziki])

# Returns a new Tzatziki::Site instance
module SpecHelper
  
  def get_test_site
    Tzatziki::Site.new(
      File.join(File.dirname(__FILE__), *%w[example source]),
      File.join(File.dirname(__FILE__), *%w[example destination])
    )
  end
  
  def get_test_api
    Tzatziki::Site.new(
      File.join(File.dirname(__FILE__), *%w[example source the_google]),
      File.join(File.dirname(__FILE__), *%w[example destination]),
      get_test_site
    )
  end
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end