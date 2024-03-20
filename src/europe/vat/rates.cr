require "http/client"
require "xml"

module Europe
  module Vat
    module Rates
      FALLBACK_RATES = {
        "AT" => 20.0, "BE" =>21.0, "BG" => 20.0, "CY" => 19.0, "CZ" => 21.0, "DE" =>19.0, "DK" => 25.0,
        "EE" => 22.0, "EL" =>24.0, "ES" => 21.0, "FI" => 24.0, "FR" => 20.0, "UK" =>20.0, "HR" => 25.0,
        "HU" => 27.0, "IE" =>23.0, "IT" => 22.0, "LT" => 21.0, "LU" => 17.0, "LV" =>21.0, "MT" => 18.0,
        "NL" => 21.0, "PL" =>23.0, "PT" => 23.0, "RO" => 19.0, "SE" => 25.0, "SI" =>22.0, "SK" => 20.0
      }
      RATES_URL = "https://ec.europa.eu/taxation_customs/" \
                  "business/vat/telecommunications-broadcasting" \
                  "-electronic-services/national-vat-rules_en"

      def self.retrieve
        response = HTTP::Client.get(RATES_URL)
        return FALLBACK_RATES if response.status_code > 400
        extract_rates(response.body)
      end

      def self.extract_rates(json_string : String)
        rates = {} of String => Int32
        begin
          data = json_string.scan(%r{\<tbody\>(.*)\<\/tbody\>}m)
                            .first.captures.first
        rescue Enumerable::EmptyError
          return FALLBACK_RATES
        end

        xml = XML.parse_html(data || "")
        xml.children[1].children[0].children.each_with_index do |result, index|
          next if index < 3
          next if result.children.empty?

          country = Europe::Countries::Reversed.generate(:name)[result.children[0].children[0].to_s]
          rates[country.to_s] = result.children[3].children[0].to_s.to_i32
        end

        rates
      end
    end
  end
end
