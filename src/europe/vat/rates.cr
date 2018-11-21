require "http/client"
require "json"

module Europe
  module Vat
    module Rates
      RATES_URL = "https://jsonvat.com"

      def self.retrieve
        response = HTTP::Client.get(RATES_URL)
        return {"failed" => 1} if response.status_code > 400
        extract_rates(response.body)
      end

      def self.extract_rates(json_string : String)
        data = JSON.parse(json_string)

        rates = {} of String => Int32
        return rates unless data

        data["rates"].as_a.each do |object|
          rates[object["code"].to_s] =
            object["periods"].as_a.first["rates"]["standard"].to_s
              .gsub(".0", "").to_i32
        end
        rates
      end
    end
  end
end
