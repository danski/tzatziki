require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Document do

  it "should be testable"
  it "should be convertible"
  it "should be documentable"
  
  it "can include types"
  it "can include specifications"
  
  it "should include included specifications into the request options at the appropriate level"
  it "should include included types into the request options at the appropriate level"
  
  it "can have multiple specifications"
  it "can have only one signing specification"
  it "should raise an error if more than one signing specification is found"
  
end