require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "EbcdicConverter" do

  describe "ebcdic_to_i" do
    it "doesn't convert last digit if it's already a number" do
      "123".ebcdic_to_i.should == 123
    end
    it "converts last digit if it's not a number" do
      "12A".ebcdic_to_i.should == 121
    end
    it "converts last digit to negative if ebcdic says it is" do
      "12K".ebcdic_to_i.should == -122
    end
    it "converts last digit to 0 if it's a } OR {" do
      "00012}".ebcdic_to_i.should == 120
      "00012{".ebcdic_to_i.should == -120
    end
  end
end
