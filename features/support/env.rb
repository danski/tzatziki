$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'tzatziki'
require 'spec/expectations'

World do |world|
  
  world.extend(Test::Unit::Assertions)
  
  world
end
