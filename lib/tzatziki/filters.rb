# Taken mostly from Jekyll - Thanks Mojombo!

module Tzatziki
  
  module Filters
    
    attr_accessor :inline_rendered_data
    
    def textilize(input)
      RedCloth.new(input).to_html
    end
    
    def render_table(input)
      return xml_escape(input) unless input.is_a?(Hash)
      return "" if input.empty?
      self.inline_rendered_data = (inline_rendered_data || {}).deep_merge(input)
      inner = input.inject("") do |memo, (key, value)|
        frag = "<dt>#{key}</dt><dd>#{render_table(value)}</dd>"
        self.inline_rendered_data[key] =  frag
        memo << frag
      end
      "<dl>#{inner}</dl>"
    end
    
    def date_to_string(date)
      date.strftime("%d %b %Y")
    end

    def date_to_long_string(date)
      date.strftime("%d %B %Y")
    end
    
    def date_to_xmlschema(date)
      date.xmlschema
    end
    
    def xml_escape(input)
      input.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
    end
    
    def number_of_words(input)
      input.split.length
    end
    
    # Returns all content before the first-encountered <hr /> tag.
    # Allows authors to mark the fold with an hr in their drafts.
    # e.g. {{ content | before_fold }}
    def before_fold(input)
      input.split("<hr").first
    end
    
    def array_to_sentence_string(array)
      connector = "and"
      case array.length
      when 0
        ""
      when 1
        array[0].to_s
      when 2
        "#{array[0]} #{connector} #{array[1]}"
      else
        "#{array[0...-1].join(', ')}, #{connector} #{array[-1]}"
      end
    end

  end  
end
