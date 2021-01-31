require "./../spec_helper"

describe Europe::Vat do
  it "should validate number as false" do
    Europe::Vat.validate("NL123456789B01")[:valid].should be_false
  end

  it "should validate number as true" do
    # PostNL
    Europe::Vat.validate("NL009291477B01")[:valid].should be_true
  end
end
