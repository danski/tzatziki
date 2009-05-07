require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Example do

  before(:all) do
    @api = get_test_api
    @example = @api.documents["search"].examples.values.first
  end

  it "should inherit the payload from the document" do
    doc = @example.document
    @example.document = nil
    @example.data[:response].should be_nil
    @example.document = doc
    doc.data[:response].should_not be_empty
    @example.data[:response].should == doc.data[:response]
  end
  
end