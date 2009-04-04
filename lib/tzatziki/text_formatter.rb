=begin
  Contains methods for formatting terminal output.
  Innards shamelessly stolen from rspec's innards.
=end

module Tzatziki
  module TextFormatter
    module TTYFormatter
      
      class << self
        attr_accessor :colour
      end
      Tzatziki::TextFormatter::TTYFormatter.colour = true
      
      def make_fabulous(text, colour_code)
        return text unless !Tzatziki.out.tty? or Tzatziki::TextFormatter::TTYFormatter.colour
        "#{colour_code}#{text}\e[0m"
      end

      def output_to_tty?
        begin
          @output.tty? || ENV.has_key?("AUTOTEST")
        rescue NoMethodError
          false
        end
      end

      def green(text); make_fabulous(text, "\e[32m"); end
      def red(text); make_fabulous(text, "\e[31m"); end
      def yellow(text); make_fabulous(text, "\e[33m"); end
      def blue(text); make_fabulous(text, "\e[34m"); end
    
    end #module TTYFormatter
  end # module TextFormatter
end # module Tzatziki