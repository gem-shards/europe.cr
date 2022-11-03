require "./../spec_helper"

describe Europe::Vat::Rates do
  it "should return VAT rates" do
    rates = Europe::Vat::Rates.retrieve

    (rates.size > 20).should be_true

    rates.keys.includes?("NL").should be_true
    rates.keys.includes?("DE").should be_true
    rates.keys.includes?("ES").should be_true

    rates.keys.includes?("GG").should be_false
  end
end
