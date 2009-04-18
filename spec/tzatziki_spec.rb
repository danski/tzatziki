require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki do
  
  describe "command line tool" do
    before(:each) do
      @taz = File.join(File.dirname(__FILE__), "..", "bin", "taz")
      @source_path = File.join(File.dirname(__FILE__), "example", "source")
      @destination_path = File.join(File.dirname(__FILE__), "example", "destination")
      FileUtils.rm_r(@destination_path) 
      FileUtils.mkdir_p(@destination_path)
    end

    it "should test and generate the documents" do
      output = `#{@taz} #{@source_path} #{@destination_path}`
      Dir.entries(@destination_path).length.should == 6
    end
    
    it "should copy the default templates when given the --generate option"

    it "should only run the test suites when run with the --nodoc option" do
      output = `#{@taz} --nodoc #{@source_path} #{@destination_path}`
      Dir.entries(@destination_path).should == [".", ".."]
    end
    it "should specify a new config file for this suite given the --config option"
    it "should not compile documents if there are test failures when given the --fatal option"
    it "should highlight document syntax when the --highlight option is given"
    
    it "should provide a task for freezing the built-in specifications into a local folder"
    it "should provide a task for freezing the built-in types into a local folder"
  end
end