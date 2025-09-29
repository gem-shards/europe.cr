module Europe
  module Countries
    # Represents a European country with its properties
    class Country
      getter code : Symbol
      getter name : String
      getter source_name : String
      getter official_name : String
      getter tld : String
      getter currency : String
      getter capital : String

      def initialize(@code : Symbol, @name : String, @source_name : String,
                    @official_name : String, @tld : String, @currency : String,
                    @capital : String)
      end

      # Create a Country instance from a code and properties hash or named tuple
      def self.from_hash(code : Symbol, properties)
        new(
          code: code,
          name: properties[:name],
          source_name: properties[:source_name],
          official_name: properties[:official_name],
          tld: properties[:tld],
          currency: properties[:currency],
          capital: properties[:capital]
        )
      end
    end
  end
end
