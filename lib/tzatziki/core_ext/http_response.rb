require 'net/http'

class Net::HTTPResponse
  
  def compare!(specification_hash, variable_payload={})
    header_fail = false
    specification_hash.inject([true, []]) do |result, (key, value)|
      ok, message = case key
                    when :status
                      Assertions.assert_status(self, value.to_s.liquify(variable_payload))
                    when :headers
                      Assertions.assert_headers(self, value.deep_liquify(variable_payload))
                    when :kind
                      Assertions.assert_kind(self, value.to_s.liquify(variable_payload))
                    when :body
                      Assertions.assert_body(self, value.deep_liquify(variable_payload))
                    end
      last_ok = result.first
      messages = result.last
      messages << message
      result = (last_ok ? ok : false), messages.flatten.compact
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
    when /(yaml|yml)/
      :yaml
    when /css/
      :css
    end
  end
  
  # Marshals the response into a hash suitable for inclusion in a template payload
  def to_payload_hash
    headers = {}
    to_hash.each do |key, value|
      headers[key] = value.flatten.join
    end
    {
      :kind=>kind,
      :code=>self.code,
      :status=>Net::HTTPResponse::CODE_TO_OBJ[code.to_s].to_s.split("::HTTP").last.downcase,
      :body=>self.body,
      :headers=>headers
    }
  end
  
  def to_nokogiri
    return (kind == :html)? Nokogiri::HTML(self.body.to_s) : Nokogiri::XML(self.body.to_s)
  end
  
  def parse_body
    case kind
    when :yaml
      YAML.load(self.body)
    when :json
      JSON.parse(self.body)
    else
      raise RuntimeError, "Only JSON and YAML responses can be parsed at this time."
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
          return ok, ("expected code of class '#{arg}' but response code was of type #{klasses.join(" / ")}" unless ok)
        end
      end
      
      # Headers is expected to be a uniform key/value list of HTTP headers with their associated expected values.
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
      
      def assert_kind(response, arg)
        errors = []
        r_kind = response.kind.to_s
        errors << "Expected kind to be #{arg.inspect} but was #{r_kind.inspect}" unless r_kind == arg
        ok = errors.empty?
        return ok, (errors unless ok)
      end
      
      # Body assertions are expected to be a keyed list of expectation types, which may have either a single argument or an array of 
      # arguments as the value, like so:
      # body:
      #   matches: this string # a simple string comparison asserting that 'this string' appears anywhere in the response body.
      #   xpath: //html # this will run an XPath expectation on the body, checking for the single expression //html
      #   css: ["body div", "body p"] # this will run two CSS expectations on the body, checking for the presence of body div and body p.
      #   values: # works for both JSON and YAML requests
      #     i_am_a_key_in_the_json_object: i_am_the_expected_value
      #     i_am_another_key:
      #       with_nested_values: which_are_also_expected_to_be_present
      def assert_body(response, arg)
        errors = []
        arg.each do |key, value|
          meth = "assert_#{key.to_s.downcase}"
          raise RuntimeError, "#{key.inspect} is not a supported expectation type." unless BodyAssertions.respond_to?(meth)
          # FIXME the call for 'values' is broken by the pointered argument
          m_ok, m_errors = (meth=="assert_values")? BodyAssertions.send(meth, response, value) : BodyAssertions.send(meth, response, *value)
          errors << m_errors unless m_ok
        end
        errors = errors.flatten.compact
        ok = errors.empty?
        return ok, (errors unless ok)
      end

    end # class << self
    
    module BodyAssertions
      class << self
        
        def assert_matches(response, *args)
          errors = []
          args.each do |string|
            errors << "Body was expected to contain #{string.inspect}" unless response.body.to_s.include?(string)
          end
          ok = errors.empty?
          return ok, (errors unless ok)
        end
        
        def assert_xpath(response, *args)
          errors = []
          document = response.to_nokogiri
          args.each do |string|
            errors << "Body was expected to match XPath expression #{string.inspect}" unless document.xpath(string).any?
          end
          ok = errors.empty?
          return ok, (errors unless ok)
        end
        
        def assert_css(response, *args)
          errors = []
          document = response.to_nokogiri
          args.each do |string|
            errors << "Body was expected to match CSS selector #{string.inspect}" unless document.css(string).any?
          end
          ok = errors.empty?
          return ok, (errors unless ok)
        end
        
        def assert_values(response, arg)
          body = response.parse_body
          errors = assert_hash_match(body, arg)
          ok = errors.empty?
          return ok, (errors unless ok)
        end
          
        private
        def assert_hash_match(data, expectations, key_path=[])
          errors = []
          data = data.deep_symbolize
          expectations = expectations.deep_symbolize
          text_path = (key_path.empty?)? "root of parsed object" : "object path /#{key_path.join("/")}"
          
          expectations.each do |key, value|
            # Assert that the key is present
            unless data.include?(key)
              errors << "Expecting key #{key} to be present but was not found at #{text_path}"
              next
            end
            found_value = data[key]
            if value.is_a?(Hash)
              # If value is a hash, recurse at the current key path
              errors << assert_hash_match(data[key], value, key_path+[key])
            else
              # Other types, we just match the value
              errors << "Expecting value at key #{key.inspect} to be #{value.inspect} at #{text_path} but found value #{found_value.inspect}" unless value == found_value
            end
          end
          return errors.flatten.compact
        end
          
        
      end # class << self
    end # module BodyAssertions
    
  end # module Assertions
  
end # class HTTPResponse