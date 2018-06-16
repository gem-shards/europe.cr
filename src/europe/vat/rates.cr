require "http/client"
require "xml"

module Europe
  module Vat
    module Rates
      RATES_URL = "https://europa.eu/youreurope/business/" \
                  "vat-customs/buy-sell/vat-rates/index_en.htm"

      def self.retrieve
        response = HTTP::Client.get(RATES_URL)
        return {"failed" => 1} if response.status_code > 400
        extract_rates(response.body)
      end

      def self.extract_rates(html_string : String)
        xml = XML.parse_html(html_string)
        data = xml.xpath_node(
          "//div[@id='eucontentpage']/xhtml_fragment/div[1]/table/tbody"
        )

        rates = {} of String => Int32
        return rates unless data

        data.children.select(&.element?).each_with_index do |node, index|
          next if index < 2
          rates[node.children[3].children[0].content] =
            node.children[5].children[0].content.to_i
        end

        rates
      end
    end
  end
end
