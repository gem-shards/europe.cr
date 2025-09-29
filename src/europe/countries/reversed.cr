module Europe
  module Countries
    # Provides functionality to create reversed lookups of country data
    module Reversed
      # Generate a reversed lookup hash based on a country property
      # Returns a hash where the keys are property values and the values are country codes or arrays of country codes
      def self.generate(property : Symbol)
        result = {} of String => Symbol | Array(Symbol)

        Countries.all.each do |code, country|
          # Get the property value based on the property symbol
          value = case property
                 when :name
                   country.name
                 when :source_name
                   country.source_name
                 when :official_name
                   country.official_name
                 when :tld
                   country.tld
                 when :currency
                   country.currency
                 when :capital
                   country.capital
                 else
                   next # Skip if property not found
                 end.to_s

          # Add to the result hash
          if result.has_key?(value)
            # If we already have this value, convert to array if needed
            if result[value].is_a?(Array)
              result[value].as(Array) << code
            else
              result[value] = [result[value].as(Symbol), code]
            end
          else
            # First occurrence of this value
            result[value] = code
          end
        end

        result
      end
    end
  end
end
