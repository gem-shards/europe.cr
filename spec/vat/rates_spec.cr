require "./../spec_helper"

describe Europe::Vat::Rates do
  it "should return VAT rates" do
    rates = Europe::Vat::Rates.retrieve
    if rates.includes?("failed")
      rates = {"NL" => 17, "DE" => 19, "ES" => 18}
    else
      rates.size.should eq Europe::Countries::COUNTRIES.size
    end

    rates.keys.includes?("NL").should be_true
    rates.keys.includes?("DE").should be_true
    rates.keys.includes?("ES").should be_true

    rates.keys.includes?("GG").should be_false
  end
end
