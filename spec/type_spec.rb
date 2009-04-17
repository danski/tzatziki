require File.dirname(__FILE__) + '/spec_helper'

describe Tzatziki::Type do

  before(:each) do
    @type = Tzatziki::Type.new("", get_test_site)
  end

  it "is documentable" do
    @type.should be_kind_of(Tzatziki::Documentable)
  end
  it "is parsable" do
    @type.should be_kind_of(Tzatziki::Parsable)
  end
  
end
