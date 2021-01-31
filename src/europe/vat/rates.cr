require "http/client"
require "xml"

module Europe
  module Vat
    module Rates
      RATES_URL = "https://ec.europa.eu/taxation_customs/" \
                  "business/vat/telecommunications-broadcasting" \
                  "-electronic-services/vat-rates_en"

      def self.retrieve
        response = HTTP::Client.get(RATES_URL)
        return {"failed" => 1} if response.status_code > 400
        extract_rates(response.body)
      end

      def self.extract_rates(json_string : String)
        rates = {} of String => Int32
        data = json_string.scan(%r{\<tbody\>(.*)\<\/tbody\>}m)
          .first.captures.first

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
