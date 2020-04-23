require "http/client"
require "json"

module Europe
  module Vat
    module Rates
      RATES_URL = "https://euvat.ga/rates.json"

      def self.retrieve
        response = HTTP::Client.get(RATES_URL)
        return {"failed" => 1} if response.status_code > 400
        extract_rates(response.body)
      end

      def self.extract_rates(json_string : String)
        data = JSON.parse(json_string)

        rates = {} of String => Int32
        return rates unless data
        data["rates"].as_h.each do |country, data|
          rates[country.to_s] =
            data["standard_rate"].to_s.gsub(".0", "").to_i32
        end

        rates
      end
    end
  end
end
