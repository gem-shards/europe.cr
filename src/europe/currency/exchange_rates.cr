require "http/client"
require "json"

module Europe
  module Currency
    module ExchangeRates
      EXCHANGE_URL = "https://floatrates.com/daily/eur.json"

      def self.retrieve
        response = HTTP::Client.get(EXCHANGE_URL)
        extract_rates(response.body)
      end

      def self.extract_rates(json_string)
        data = JSON.parse(json_string)
        rates = {
          date: parse_time(data["usd"]["date"].to_s),
          rates: {} of String => Float64,
        }

        data.as_h.keys.each do |currency|
          rates[:rates][currency.upcase] =
          data[currency]["rate"].to_s.to_f
        end
        rates
      end

      def self.parse_time(time : String)
        splitted_date = time.split(" ")
        splitted_time = splitted_date[4].split(":")
        Time.new(
          splitted_date[3].to_i32,
          parse_month(splitted_date[2]).to_i32,
          splitted_date[1].to_i32,
          splitted_time[0].to_i32,
          splitted_time[1].to_i32,
          splitted_time[2].to_i32,
          location: Time::Location::UTC
        )
      end

      def self.parse_month(month : String)
        case month
        when "Nov" then 11
        else 1
        end
      end
    end
  end
end
