$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed
require 'dependencies'

module Tzatziki
  
  class << self
    attr_accessor :source, :destination, :host, :pygments, :write_docs, :run_tests, :site, :out
  end
  
  # Configuration
  Tzatziki.host = "http://localhost"
  Tzatziki.pygments = false
  Tzatziki.write_docs = true
  Tzatziki.run_tests = true
  Tzatziki.out = $stdout
    
  def self.process!(source, destination)
    Taz.out.write "Tzatziki is reading the specifications from #{source}...\n"
    Tzatziki.site = Tzatziki::Site.new(source, destination)
    Taz.out.write "=> Done.\n"
    test Tzatziki.site if run_tests
    document Tzatziki.site if write_docs
  end 
   
  def self.test(site)
    Taz.out.write "Tzatziki is testing against the specifications...\n"
    Tzatziki.site.test!
  end
  
  def self.document(site)
    Taz.out.write "Tzatziki is writing the documentation to #{Tzatziki.site.destination} \n"
    Tzatziki.site.document!
  end
  
  def self.template_helpers
    []
  end
  
  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
  
end
Taz = Tzatziki