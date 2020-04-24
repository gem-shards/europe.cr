require "http/client"
require "xml"

module Europe
  module Vat
    module Rates
      RATES_URL = "https://europa.eu/youreurope/business/taxation/" \
                  "vat/vat-rules-rates/index_en.htm"

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

          rates[result.children[3].children[0].to_s] =
            result.children[5].children[0].to_s.to_i32
        end

        rates
      end
    end
  end
end
