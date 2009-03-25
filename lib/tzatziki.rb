# Core requires
require 'rubygems'
# Stdlib requires
require 'fileutils'
require 'yaml'
# Gem requires
require 'liquid'
require 'redcloth'

module Tzatziki
  
  class << self
    attr_accessor :source, :destination, :domain, :pygments, :write_docs, :run_tests
  end
  
  Tzatziki.domain = "http://localhost"
  Tzatziki.pygments = false
  Tzatziki.write_docs = true
  Tzatziki.run_tests = true
  
  def self.process!(source, destination)
    if run_tests
      puts "Running tests against #{domain}..."
      test(source, destination)
    end
    if write_docs
      puts "Generating documentation in #{destination}"
      document(source, destination)
    end
    puts "Out of Tzatziki."
  end
  
  def self.test(source, destination)
    
  end
  
  def self.document(source, destination)
    
  end
  
  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
  
end