require "./../spec_helper"

describe Europe::Countries do
  it "should return countries by name" do
    reversed_name_hash =
      Europe::Countries::Reversed.generate(:name)
    reversed_name_hash["Netherlands"].should eq :NL
    reversed_name_hash["Ireland"].should eq :IE

    reversed_currency_hash =
      Europe::Countries::Reversed.generate(:currency)
    reversed_currency_hash["EUR"].as(Array).size.should eq 17
  end

  it "should return countries in eurozone" do
    Europe::Countries.eurozone.includes?(:DE).should eq true
    Europe::Countries.eurozone.includes?(:UK).should eq false
  end
end
