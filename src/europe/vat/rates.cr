require "http/client"
require "xml"

module Europe
  module Vat
    module Rates
      FALLBACK_RATES = {
        "AT" => 20.0, "BE" => 21.0, "BG" => 20.0, "CY" => 19.0, "CZ" => 21.0, "DE" => 19.0, "DK" => 25.0,
        "EE" => 22.0, "EL" => 24.0, "ES" => 21.0, "FI" => 25.5, "FR" => 20.0, "HR" => 25.0,
        "HU" => 27.0, "IE" => 23.0, "IT" => 22.0, "LT" => 21.0, "LU" => 17.0, "LV" => 21.0, "MT" => 18.0,
        "NL" => 21.0, "PL" => 23.0, "PT" => 23.0, "RO" => 19.0, "SE" => 25.0, "SI" => 22.0, "SK" => 23.0
      }
      RATES_URL = "https://europa.eu/youreurope/business/taxation/vat" \
                  "/vat-rules-rates/index_en.htm"

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

      def self.extract_rates(html_content : String)
        rates = {} of String => Float64

        begin
          # Extract the table body content
          tbody_match = html_content.scan(%r{\<tbody\>(.*?)\<\/tbody\>}m).first?

          return FALLBACK_RATES unless tbody_match && tbody_match.captures.first?

          data = tbody_match.captures.first
          return FALLBACK_RATES if data.nil? || data.empty?

          # Parse the HTML
          xml = XML.parse_html(data)

          # Safety checks for XML structure
          return FALLBACK_RATES if xml.nil? || xml.children.empty? || xml.children.size < 2
          return FALLBACK_RATES if xml.children[1].children.empty? || xml.children[1].children.size < 1

          # Extract rates from table rows
          xml.children[1].children[0].children.each_with_index do |result, index|
            # Skip header rows and empty rows
            next if index < 3
            next if result.children.empty?

            # Safety checks for row structure
            next if result.children.size < 1 || result.children[0].children.empty?
            next if result.children.size < 4 || result.children[3].children.empty?

            # Get country code from country name
            country_name = result.children[0].children[0].to_s
            country_map = Europe::Countries::Reversed.generate(:name)

            # Skip if country name is not found in the map
            next unless country_map.has_key?(country_name)

            country_code = country_map[country_name]

            # Extract and convert rate to float
            rate_text = result.children[3].children[0].to_s
            begin
              # Try to parse as float first (handles decimal points)
              rates[country_code.to_s] = rate_text.to_f
            rescue
              # Fall back to integer parsing if float parsing fails
              begin
                rates[country_code.to_s] = rate_text.to_i32.to_f
              rescue
                # Skip this entry if parsing fails
                next
              end
            end
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
