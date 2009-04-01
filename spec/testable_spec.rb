require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Testable do
  
  before(:all) do
    class ::TestTestable
      include Tzatziki::Testable
    end
  end
  before(:each) do
    @testable = ::TestTestable.new
  end

  it "should provide defaults for the request object" do
    Tzatziki::Testable.request_defaults.should be_kind_of(Hash)
  end
  it "should provide defaults for the response assertions" do
    Tzatziki::Testable.response_defaults.should be_kind_of(Hash)
  end
  
  it "should set up a request factory when given a descriptive hash"

  it "should manufacture requests based on the data found in the parsable hash"
  it "should manufacture response assertions based on the data found in the parsable hash"
  
  it "should make the response data available to the template payload"
  
end