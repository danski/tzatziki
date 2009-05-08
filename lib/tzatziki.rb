$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed
# Core requires
require 'rubygems'
# Stdlib requires
require 'fileutils'
require 'yaml'
require 'net/http'
# Gem requires
require 'json'
require 'liquid'
require 'redcloth'
require 'maruku'
require 'jekyll'
require 'randexp'
require 'mash'
require 'nokogiri'
# Tzatziki requires
require 'tzatziki/core_ext/string'
require 'tzatziki/core_ext/hash'
require 'tzatziki/core_ext/http_request'
require 'tzatziki/core_ext/http_response'
require 'tzatziki/text_formatter'
require 'tzatziki/errors'
require 'tzatziki/parsable'
require 'tzatziki/documentable'
require 'tzatziki/testable'
require 'tzatziki/api'
require 'tzatziki/site'
require 'tzatziki/document'
require 'tzatziki/example'
require 'tzatziki/layout'
require 'tzatziki/type'
require 'tzatziki/specification'
# Extensions to Liquid's template markup
require 'tzatziki/filters'
require 'tzatziki/tags/highlight'
require 'tzatziki/tags/include'

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
    Taz.out.write "Done. Enjoy your Tzatziki. \n"
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