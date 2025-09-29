require "./../spec_helper"

describe Europe::Countries do
  describe ".all" do
    it "returns all countries" do
      countries = Europe::Countries.all
      countries.size.should eq(28)
      countries[:NL].name.should eq("Netherlands")
      countries[:DE].currency.should eq("EUR")
    end
  end

  describe ".get" do
    it "returns a specific country by code" do
      country = Europe::Countries.get(:FR)
      country.name.should eq("France")
      country.capital.should eq("Paris")
    end
  end

  describe ".find_by" do
    it "finds countries by property value" do
      countries = Europe::Countries.find_by(:currency, "EUR")
      countries.size.should eq(19)
      countries.map(&.code).should contain(:DE)
      countries.map(&.code).should contain(:FR)
      countries.map(&.code).should_not contain(:UK)
    end
  end

  describe ".eurozone" do
    it "returns countries in the eurozone" do
      eurozone = Europe::Countries.eurozone
      eurozone.should contain(:DE)
      eurozone.should_not contain(:UK)
      eurozone.size.should eq(19)
    end
  end

  describe "Reversed" do
    it "generates reversed lookup by name" do
      reversed_name_hash = Europe::Countries::Reversed.generate(:name)
      reversed_name_hash["Netherlands"].should eq(:NL)
      reversed_name_hash["Ireland"].should eq(:IE)
    end

    it "generates reversed lookup by currency" do
      reversed_currency_hash = Europe::Countries::Reversed.generate(:currency)
      reversed_currency_hash["EUR"].as(Array).size.should eq(19)
      reversed_currency_hash["EUR"].as(Array).should contain(:DE)
    end
  end
end
