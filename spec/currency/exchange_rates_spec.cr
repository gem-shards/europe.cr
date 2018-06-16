require "./../spec_helper"

describe Europe::Currency::ExchangeRates do
  it "should return currency data" do
    rates = Europe::Currency::ExchangeRates.retrieve
    rates[:rates]["GBP"].should be_a Float64
  end
end
