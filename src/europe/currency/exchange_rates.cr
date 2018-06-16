require "http/client"
require "xml"

module Europe
  module Currency
    module ExchangeRates
      EXCHANGE_URL = "http://www.ecb.europa.eu/stats/" \
                     "eurofxref/eurofxref-daily.xml"

      def self.retrieve
        response = HTTP::Client.get(EXCHANGE_URL)
        extract_rates(response.body)
      end

      def self.extract_rates(xml_string : String)
        data = XML.parse(xml_string)
        rates = {
          date: Time.parse(
            data.children.first.children[5].children[1].attributes[0].content,
            "%F", location: Time::Location::UTC),
          rates: {} of String => Float64,
        }

        data.children.first.children[5].children[1].children.select(&.element?).each do |node|
          next unless node.name == "Cube"
          rates[:rates][node.attributes[0].content] =
            node.attributes[1].content.to_f
        end
        rates
      end
    end
  end
end
