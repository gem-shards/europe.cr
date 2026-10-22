require "http/client"
require "json"

module Europe
  module Vat
    module Rates
      FALLBACK_RATES = {
        "AT" => 20.0, "BE" => 21.0, "BG" => 20.0, "CY" => 19.0, "CZ" => 21.0, "DE" => 19.0, "DK" => 25.0,
        "EE" => 24.0, "EL" => 24.0, "ES" => 21.0, "FI" => 25.5, "FR" => 20.0, "HR" => 25.0,
        "HU" => 27.0, "IE" => 23.0, "IT" => 22.0, "LT" => 21.0, "LU" => 17.0, "LV" => 21.0, "MT" => 18.0,
        "NL" => 21.0, "PL" => 23.0, "PT" => 23.0, "RO" => 21.0, "SE" => 25.0, "SI" => 22.0, "SK" => 23.0
      }
      RATES_URL = "https://raw.githubusercontent.com/benbucksch/eu-vat-rates" \
                  "/refs/heads/master/rates.json"

      # HTTP timeout in seconds
      HTTP_TIMEOUT = 10.seconds

      def self.retrieve
        begin
          client = HTTP::Client.new(URI.parse(RATES_URL))
          client.connect_timeout = HTTP_TIMEOUT
          client.read_timeout = HTTP_TIMEOUT

          response = client.get(URI.parse(RATES_URL).path)

          # Check for successful response
          if response.success?
            return extract_rates(response.body)
          else
            # Log the error and return fallback rates
            puts "Failed to retrieve VAT rates: HTTP #{response.status_code}"
            return FALLBACK_RATES
          end
        rescue ex : Exception
          # Handle any exceptions (network issues, timeouts, etc.)
          puts "Error retrieving VAT rates: #{ex.message}"
          return FALLBACK_RATES
        ensure
          client.try &.close
        end
      end

      def self.extract_rates(json_content : String)
        rates = {} of String => Float64

        begin
          JSON.parse(json_content)["rates"].as_h.each do |code, data|
            # Source uses ISO "GR", this library uses VIES "EL" for Greece
            code = "EL" if code == "GR"
            rate = data["standard_rate"]
            rates[code] = rate.as_f? || rate.as_i.to_f
          end

          # Return fallback rates if we couldn't extract any valid rates
          return FALLBACK_RATES if rates.empty?

          rates
        rescue ex : Exception
          # Handle any parsing exceptions
          puts "Error parsing VAT rates: #{ex.message}"
          return FALLBACK_RATES
        end
      end
    end
  end
end
