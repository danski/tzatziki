module Tzatziki
  module Parsable
    
    attr_accessor :raw
    attr_accessor :data
    attr_accessor :inline_data
    
    def parse!(raw_doc = self.raw, defaults={})
      self.data, self.raw = extract_yaml(raw_doc, nil, defaults)
    end
    
    # Overrides and extends documentable
    def payload
      self.data.deep_symbolize.merge(:inline_data=>inline_data)
    end
    
    # Extracts the YAML block-by-block from the given document. YAML blocks are expected
    # to begin with a line reading '---' and end with a line reading '==='.
    # All but the first YAML block will insert a hash render helper into the document.
    def extract_yaml(parsable_string, replacement_pattern=nil, defaults={})
      self.inline_data = []
      data_table = defaults
      out = parsable_string.dup
      i = -1
      while out =~ /^(---\s*\n.*?)(\n===\s*$)/m
        yaml = $1.dup
        out = out.gsub(/#{Regexp.escape(yaml)}#{Regexp.escape($2)}/m,((i>-1)? "{{ document.inline_data[#{i}] | render_table }}" : ""))
        d = YAML.load(yaml)
        
        if d.is_a?(Hash)
          self.inline_data << d if i > -1
          data_table = data_table.deep_merge(d)
        end
        
        d = nil; i += 1
      end
      data_table = data_table.deep_symbolize
      return data_table, out
    end
    
  end
end