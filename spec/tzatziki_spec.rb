require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki do
  
  it "should only run the test suites when run with the --nodoc option"
  it "should only run the document generator when run with the --notest option"
  it "should specify a new config file for this suite given the --config option"
  it "should not compile documents if there are test failures when given the --fatal option"
  
end