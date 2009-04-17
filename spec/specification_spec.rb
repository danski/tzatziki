require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Specification do

  before(:each) do
    @spec = Tzatziki::Specification.new("", get_test_site)
  end

  it "is documentable" do
    @spec.should be_kind_of(Tzatziki::Documentable)
  end
  it "is parsable" do
    @spec.should be_kind_of(Tzatziki::Parsable)
  end
  
end