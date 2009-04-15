module Tzatziki
  module Parsable
    
    attr_accessor :raw
    attr_accessor :data
    
    def parse!(raw_doc = self.raw, defaults={})
      self.data, self.raw = extract_yaml(raw_doc, nil, defaults)
    end
    
    # Overrides and extends documentable
    def payload
      self.data
    end
    
    def extract_yaml(parsable_string, replacement_pattern=nil, defaults={})
      data_table = defaults
      out = parsable_string.dup      
      while out =~ /^(---\s*\n.*?)(\n===\s*$)/m
        yaml = $1.dup
        out = out.gsub(/#{yaml}#{$2}/m,"")
        d = YAML.load(yaml)
        data_table = data_table.deep_merge(d) if d.is_a?(Hash)
        d = nil
      end
      data_table = data_table.deep_symbolize
      return data_table, out
    end
    
  end
end