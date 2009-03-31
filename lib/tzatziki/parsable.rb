module Tzatziki
  module Parsable
    
    attr_accessor :raw
    attr_accessor :data, :post_parse
    
    def parse!(path_to_source_file)
      read(path_to_source_file)
      self.data, self.post_parse = extract_yaml(self.raw)
    end
    
    # Reads the source file into an instance variable called 'src'.
    # Returns nothing.    
    def read(path_to_source_file)
      f = File.open(path_to_source_file)
      self.raw = f.read
    end
    
    def extract_yaml(parsable_string, replacement_pattern=nil)
      data_table = {}
      out = parsable_string.dup      
      while out =~ /^(---\s*\n.*?)(\n===\s*$)/m
        yaml = $1.dup
        out = out.gsub(/#{yaml}#{$2}/m,"")
        d = YAML.load(yaml)
        data_table.merge!(d)
      end
      return data_table, out
    end
    
  end
end