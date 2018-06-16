require "./../spec_helper"

describe Europe::Currency do
  it "should return currency data" do
    Europe::Currency::CURRENCIES[:EUR][:name].should eq "Euro"
    Europe::Currency::CURRENCIES[:GBP][:symbol].should eq "£"
    Europe::Currency::CURRENCIES[:SEK][:html].should eq "&#107;&#114;"
  end
end
