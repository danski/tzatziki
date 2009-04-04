require 'net/http'

class Net::HTTPResponse
  
  def compare!(specification_hash)
    specification_hash.inject([true, []]) do |result, (key, value)|
      ok, message = case key
                    when :status
                      Assertions.assert_status(self, value)
                    when :headers
                      Assertions.assert_headers(self, value)
                    when :body
                      Assertions.assert_headers(self, value)
                    end
      messages = result.last
      messages << message
      result = ok, messages.flatten.compact
    end
  end
  
  # Does a loose check against the content-type header for a number of known substrings
  # effectively a kind of casual content-type call.
  # >> some_http_response.kind
  # => :html
  def kind
    case self["content-type"]
    when /html/
      :html
    when /xml/
      :xml
    when /json/
      :json
    when /css/
      :css
    end
  end
  
  module Assertions
    class << self
      # Each assertion method returns a tuple of success (a boolean) and message, if applicable.
      # e.g. result, message = assert_status(response, "success")
      # => [false, "expected 20X status but status was 500"] # on FAIL
      # => [true, nil] # on WIN
      
      def assert_status(response, arg)
        if arg.is_a?(Integer) or arg.match(/^\d+$/)
          # Do numeric
          ok = (response.code.to_s == arg.to_s)
          return ok, ("expected #{arg}, but got #{response.code}" unless ok)
        elsif arg.match(/\d+/)
          # Do text (mask-based)
          # Expects a status code like "20X"
          ok = (response.code.to_s.match(/^#{arg.gsub("X","\\d{1}")}$/) ? true : false)
          return ok, ("expected any code of type #{arg} but response code was #{response.code}" unless ok)
        else
          # Do text (class-based)
          # Gets the constant for the current response code and compares it to the given string.
          
          # Get response classification constant (HTTPRequest::CODE_CLASS_TO_OBJ)
          # and get specific response class classes (HTTPRequest::CODE_TO_OBJ)
          klasses = [
            Net::HTTPResponse::CODE_CLASS_TO_OBJ[response.code.to_s[0..0]], 
            Net::HTTPResponse::CODE_TO_OBJ[response.code.to_s]
          ].compact.collect do |k|
              k.to_s.split("::HTTP").last.downcase
          end          
          ok = (klasses.include?(arg.downcase))
          return ok, ("expected code of class '#{klasses.first}' or specific type '#{klasses.last}' but response code was of type #{response.class.to_s.split("::HTTP").last.downcase}" unless ok)
        end
      end
      
      def assert_headers(response, arg)
        errors = []
        arg.each do |key, value|
          if response[key.to_s] != value
            errors << "header '#{key}' was expected to be '#{value}' but was '#{response[key.to_s]}'"
          end
        end
        ok = errors.empty?
        return ok, (errors unless ok)
      end
      
      def assert_body(response, arg)
      end      

    end # class << self
  end # module Assertions
  
end # class HTTPResponse