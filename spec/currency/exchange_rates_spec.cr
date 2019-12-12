require "./../spec_helper"

describe Europe::Currency::ExchangeRates do
  it "should return currency data" do
    rates = Europe::Currency::ExchangeRates.retrieve
    unless rates.is_a?(Symbol)
      rates[:rates]["GBP"].should be_a Float64
    end
  end

  it "should return error when non-valid json" do
    response = Europe::Currency::ExchangeRates.extract_rates("asdas")
    response.should be_a Symbol
    response.should eq :failed
  end

  it "should parse date based on string month name" do
    Europe::Currency::ExchangeRates.parse_month("Jun").should eq 6
  end

  it "should parse wrong month name to 1" do
    Europe::Currency::ExchangeRates.parse_month("Fake").should eq 1
  end
end
