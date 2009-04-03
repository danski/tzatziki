require 'net/http'
require File.dirname(__FILE__) + '/spec_helper'

describe Net::HTTPResponse do
  
  it "should be comparable to a specification hash"
  
  describe "response assertions" do
    it "should allow 20X-style request types as ranges"
    it "should recognise words like 'Success' as HTTP response class types e.g. HTTPSuccess"
    
    it "should recognise file uploads in the params"
    it "should automatically set the content-type to multipart form if a file is present"
  
    it "should manufacture response assertions based on the data found in the parsable hash"
    
    it "should return tuple of test result (:success,:pending,:fail) and message"
    
    it "should match against :status in the response hash"
    it "should match against :body in the response hash"
    it "should match against :body by CSS in the response hash when the returned content type is an XML variant"
    it "should match against :body by XPath in the response hash when the returned content type is an XML variant"
    it "should match against :body by XPath in the response hash when the returned content type is an JSON variant"
    it "should match against :body by XPath in the response hash when the returned content type is an YAML variant"
  end
  
end
