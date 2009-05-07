require 'net/http'
require File.dirname(__FILE__) + '/spec_helper'

describe Net::HTTPResponse do
  
  if ENV["OFFLINE"]
    it "did not run because we are offline"
  else
  
    before(:all) do
      @api = get_test_api
      @testable = @api.documents["search"]
      @success_uri = Net::HTTPRequest::Factory.specification_hash_to_uri(@testable.data[:request])
      @success_request = Net::HTTPRequest.from_hash(@testable.data[:request])
      @success_response = Net::HTTPRequest.from_hash(@testable.data[:request]) { |http, req| http.request(req) }
    end
  
    it "should allow for liquid markup referencing the request properties" do
      ok, messages = @success_response.compare!({:headers=>{"{{request.uri}}"=>"{{request.host}}"}}, @testable.template_payload)
      ok.should be_false
      messages.first.should == "header '/search' was expected to be 'www.google.com' but was ''"
    end
  
    it "should return true, [] for the success fixture on comparison" do
      ok, messages = @success_response.compare!(:status=>200)
      ok.should be_true
      messages.should be_empty
    end
    it "should return false, error array for the for the failure fixture on comparison" do
      ok, messages = @success_response.compare!(:status=>500)
      ok.should be_false
      messages.length.should == 1    
    end
    it "should return false, error array for a partial failure state" do
      ok, messages = @success_response.compare!(:status=>200, :headers=>{:"content-type" => "application/json"})
      ok.should be_false
      messages.length.should == 1
    end
    it "should return false, error array for success-fail-success failure states, ensuring that we don't introduce a regression" do
      ok, messages = @success_response.compare!(:headers=>{:"content-type" => "text/html; charset=ISO-8859-1", :status=>201})
      ok.should be_false
      messages.length.should == 1
    end
    
    describe "hash transformation" do
      it "has a numeric status code" do
        @success_response.to_payload_hash[:code].should == "200"
      end
      it "has a text status" do
        @success_response.to_payload_hash[:status].should == "ok"
      end
      it "preserves the headers" do
        @success_response.to_payload_hash[:headers]["content-type"].should == "text/html; charset=ISO-8859-1"
      end
      it "has the response body" do
        @success_response.to_payload_hash[:body].should include("<!doctype html>")
      end
      it "has the casual content-type available as 'kind'" do
        @success_response.to_payload_hash[:kind].should == :html
      end
    end
  
    describe "casual typing" do
      it "should match any part of the content-type header, e.g. 'html' to 'text/html; charset...'" do
        @success_response.kind.should == :html
      end
    end
  
    describe "response assertions" do
      before(:all) do
        @github_api = get_test_api("github")
        @yaml_testable = @github_api.documents["show_repo"]
        @yaml_testable.payload[:response][:kind].should == "yaml"
        @yaml_uri = Net::HTTPRequest::Factory.specification_hash_to_uri(@yaml_testable.data[:request])
        @yaml_request = Net::HTTPRequest.from_hash(@yaml_testable.data[:request])
        @yaml_response = Net::HTTPRequest.from_hash(@yaml_testable.data[:request]) { |http, req| http.request(req) }
        
        @json_testable = @github_api.documents["show_user"]
        @json_testable.payload[:response][:kind].should == "json"
        @json_uri = Net::HTTPRequest::Factory.specification_hash_to_uri(@json_testable.data[:request])
        @json_request = Net::HTTPRequest.from_hash(@json_testable.data[:request])
        @json_response = Net::HTTPRequest.from_hash(@json_testable.data[:request]) { |http, req| http.request(req) }        
      end
      
      describe "(successful)" do
        it "should allow 20X-style request types as ranges" do
          ok, messages = @success_response.compare!(:status=>"20X")
          ok.should be_true and messages.should be_empty
        end
        it "should recognise words like 'Success' and 'ok' as HTTP response class types e.g. HTTPSuccess" do
          ok, messages = @success_response.compare!(:status=>"success")
          ok.should be_true and messages.should be_empty
          ok, messages = @success_response.compare!(:status=>"Success")
          ok.should be_true and messages.should be_empty
          ok, messages = @success_response.compare!(:status=>"ok")
          ok.should be_true and messages.should be_empty
        end
      
        it "should match against :headers in the response hash" do
          ok, messages = @success_response.compare!(:headers=>{:"content-type"=>"text/html; charset=ISO-8859-1"})
          ok.should be_true and messages.should be_empty
        end
        
        it "should match against :body by string equality in the response hash" do
          ok, messages = @success_response.compare!(:body=>{:matches=>["html", "google"]})
          ok.should be_true
          messages.should be_empty
        end
        it "should match against :body by CSS in the response hash" do
          ok, messages = @success_response.compare!(:body=>{:css=>["html", "body div"]})
          ok.should be_true
          messages.should be_empty
        end
        it "should match against :body by XPath in the response hash" do
          ok, messages = @success_response.compare!(:body=>{:xpath=>"//html"})
          ok.should be_true
          messages.should be_empty
        end
        it "should match against :kind by matching the content-type of the request" do
          ok, messages = @success_response.compare!(:kind=>"html")
          ok.should be_true
          messages.should be_empty
        end
        it "should match against :body by JSON variable parsing in the response hash" do
          ok, messages = @json_response.compare!(:body=>{
            :values=>{
              :user=>{
                :login=>"danski",
                :email=>"dan@angryamoeba.co.uk"
              }
            }
          })
          ok.should be_true
          messages.should be_empty
        end
        it "should match against :body by YAML variable parsing in the response hash" do
          ok, messages = @yaml_response.compare!(:body=>{
            :values=>{
              :repository=>{
                :name=>"tzatziki",
                :private=>false
              }
            }
          })
          ok.should be_true
          messages.should be_empty
        end
      end
    
      describe "(failed)" do
        it "should allow 20X-style request types as ranges" do
          ok, messages = @success_response.compare!(:status=>"30X")
          ok.should be_false and messages.should_not be_empty
        end
        it "should recognise words like 'Success' and 'ok' as HTTP response class types e.g. HTTPSuccess" do
          ok, messages = @success_response.compare!(:status=>"redirect")
          ok.should be_false and messages.should_not be_empty
        end
      
        it "should match against :headers in the response hash" do
          ok, messages = @success_response.compare!(:headers=>{:foo=>"bar"})
          ok.should be_false and messages.should_not be_empty
        end
        
        it "should match against :body by string equality in the response hash" do
          ok, messages = @success_response.compare!(:body=>{:matches=>["html", "GOOD NEWS EVERYONE"]})
          ok.should be_false
          messages.should_not be_empty
        end
        it "should match against :body by CSS in the response hash" do
          ok, messages = @success_response.compare!(:body=>{:css=>["html", "google nothere"]})
          ok.should be_false
          messages.should_not be_empty
        end
        it "should match against :body by XPath in the response hash" do
          ok, messages = @success_response.compare!(:body=>{:xpath=>"//nothere"})
          ok.should be_false
          messages.should_not be_empty
        end
        
        it "should match against :kind by matching the content-type of the request" do
          ok, messages = @success_response.compare!(:kind=>"yaml")
          ok.should be_false
          messages.should_not be_empty
        end
        it "should match against :body by JSON variable parsing in the response hash" do
          ok, messages = @json_response.compare!(:body=>{
            :values=>{
              :user=>{
                :login=>"not danski",
                :email=>"notdanski@nowhere.com"
              }
            }
          })
          ok.should be_false
          messages.length.should == 2
        end
        it "should match against :body by YAML variable parsing in the response hash" do
          ok, messages = @yaml_response.compare!(:body=>{
            :values=>{
              :repository=>{
                :name=>"fooo fooooooo",
                :private=>true
              }
            }
          })
          ok.should be_false
          messages.length.should == 2
        end
      end
      

    end
  end # if ENV["offline"]
end
