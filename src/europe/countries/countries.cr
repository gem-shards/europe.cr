require "./country"

module Europe
  module Countries
    # Raw country data
    COUNTRY_DATA = {
      BE: {name: "Belgium", source_name: "Belgique/België",
           official_name: "Kingdom of Belgium",
           tld: ".be", currency: "EUR", capital: "Brussels"},
      BG: {name: "Bulgaria", source_name: "България",
           official_name: "Republic of Bulgaria",
           tld: ".bg", currency: "BGN", capital: "Sofia"},
      CZ: {name: "Czech Republic", source_name: "Česká republika",
           official_name: "Czech Republic",
           tld: ".cz", currency: "CZK", capital: "Prague"},
      DK: {name: "Denmark", source_name: "Danmark",
           official_name: "Kingdom of Denmark",
           tld: ".dk", currency: "DKK", capital: "Copenhagen"},
      DE: {name: "Germany", source_name: "Deutschland",
           official_name: "Federal Republic of Germany",
           tld: ".de", currency: "EUR", capital: "Berlin"},
      EE: {name: "Estonia", source_name: "Eesti",
           official_name: "Republic of Estonia",
           tld: ".ee", currency: "EUR", capital: "Tallinn"},
      IE: {name: "Ireland", source_name: "Éire",
           official_name: "Ireland",
           tld: ".ie", currency: "EUR", capital: "Dublin"},
      EL: {name: "Greece", source_name: "Ελλάδα",
           official_name: "Hellenic Republic",
           tld: ".gr", currency: "EUR", capital: "Athens"},
      ES: {name: "Spain", source_name: "España",
           official_name: "Kingdom of Spain",
           tld: ".es", currency: "EUR", capital: "Madrid"},
      FR: {name: "France", source_name: "France",
           official_name: "French Republic",
           tld: ".fr", currency: "EUR", capital: "Paris"},
      HR: {name: "Croatia", source_name: "Hrvatska",
           official_name: "Republic of Croatia",
           tld: ".hr", currency: "HRK", capital: "Zagreb"},
      IT: {name: "Italy", source_name: "Italia",
           official_name: "Italian Republic",
           tld: ".it", currency: "EUR", capital: "Rome"},
      CY: {name: "Cyprus", source_name: "Κύπρος",
           official_name: "Republic of Cyprus",
           tld: ".cy", currency: "EUR", capital: "Nicosia"},
      LV: {name: "Latvia", source_name: "Latvija",
           official_name: "Republic of Latvia",
           tld: ".lv", currency: "EUR", capital: "Riga"},
      LT: {name: "Lithuania", source_name: "Lietuva",
           official_name: "Republic of Lithuania",
           tld: ".lt", currency: "EUR", capital: "Vilnius"},
      LU: {name: "Luxembourg", source_name: "Luxembourg",
           official_name: "Grand Duchy of Luxembourg",
           tld: ".lu", currency: "EUR", capital: "Luxembourg City"},
      HU: {name: "Hungary", source_name: "Magyarország",
           official_name: "Hungary",
           tld: ".hu", currency: "HUF", capital: "Budapest"},
      MT: {name: "Malta", source_name: "Malta",
           official_name: "Republic of Malta",
           tld: ".mt", currency: "EUR", capital: "Valletta"},
      NL: {name: "Netherlands", source_name: "Nederland",
           official_name: "Kingdom of the Netherlands",
           tld: ".nl", currency: "EUR", capital: "Amsterdam"},
      AT: {name: "Austria", source_name: "Österreich",
           official_name: "Republic of Austria",
           tld: ".at", currency: "EUR", capital: "Vienna"},
      PL: {name: "Poland", source_name: "Polska",
           official_name: "Republic of Poland",
           tld: ".pl", currency: "PLN", capital: "Warsaw"},
      PT: {name: "Portugal", source_name: "Portugal",
           official_name: "Portuguese Republic",
           tld: ".pt", currency: "EUR", capital: "Lisbon"},
      RO: {name: "Romania", source_name: "România",
           official_name: "Romania",
           tld: ".ro", currency: "RON", capital: "Bucharest"},
      SI: {name: "Slovenia", source_name: "Slovenija",
           official_name: "Republic of Slovenia",
           tld: ".si", currency: "EUR", capital: "Ljubljana"},
      SK: {name: "Slovakia", source_name: "Slovensko",
           official_name: "Slovak Republic",
           tld: ".sk", currency: "EUR", capital: "Bratislava"},
      FI: {name: "Finland", source_name: "Suomi",
           official_name: "Republic of Finland",
           tld: ".fi", currency: "EUR", capital: "Helsinki"},
      SE: {name: "Sweden", source_name: "Sverige",
           official_name: "Kingdom of Sweden",
           tld: ".se", currency: "SEK", capital: "Stockholm"},
      UK: {name: "United Kingdom", source_name: "United Kingdom",
           official_name: "United Kingdom of Great " \
                          "Britain and Northern Ireland",
           tld: ".uk", currency: "GBP", capital: "London"},
    }

    # Cache for country instances
    @@countries : Hash(Symbol, Country)? = nil

    # Get all countries as a hash of Country objects
    def self.all
      @@countries ||= begin
        result = {} of Symbol => Country
        COUNTRY_DATA.each do |code, data|
          result[code] = Country.from_hash(code, data)
        end
        result
      end
    end

    # Get a specific country by its code
    def self.get(code : Symbol)
      all[code]
    end

    # Find countries by a specific property value
    def self.find_by(prop : Symbol, value : String)
      case prop
      when :name
        all.values.select { |country| country.name == value }
      when :source_name
        all.values.select { |country| country.source_name == value }
      when :official_name
        all.values.select { |country| country.official_name == value }
      when :tld
        all.values.select { |country| country.tld == value }
      when :currency
        all.values.select { |country| country.currency == value }
      when :capital
        all.values.select { |country| country.capital == value }
      else
        [] of Country
      end
    end

    # Get all countries that use the Euro
    def self.eurozone
      find_by(:currency, "EUR").map(&.code)
    end
  end
end
