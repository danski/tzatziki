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
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end