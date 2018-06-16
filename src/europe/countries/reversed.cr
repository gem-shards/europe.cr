module Europe
  module Countries
    module Reversed
      def self.generate(country_value : Symbol)
        rhash = {} of String => Symbol | Array(Symbol)
        COUNTRIES.each do |key, value|
          reverse_handle_value(rhash, key, value, country_value)
        end
        rhash
      end

      def self.reverse_handle_value(rhash, key, value, country_value)
        if rhash[value[country_value]]?
          reverse_handle_array(rhash, key, value, country_value)
        else
          rhash[value[country_value]] = key
        end
      end

      def self.reverse_handle_array(rhash, key, value, country_value)
        if rhash[value[country_value]].is_a?(Array)
          rhash[value[country_value]].as(Array) << key.as(Symbol)
        else
          rhash[value[country_value]] =
            [rhash[value[country_value]].as(Symbol), key]
        end
      end
    end
  end
end
