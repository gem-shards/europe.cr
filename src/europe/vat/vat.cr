require "http/client"
require "xml"

module Europe
  module Vat
    URL = "https://ec.europa.eu/taxation_customs/vies/" \
          "services/checkVatService"
    HEADERS = HTTP::Headers{"Content-Type" => "text/xml;charset=UTF-8",
                            "SOAPAction"   => ""}
    # HTTP timeout in seconds
    HTTP_TIMEOUT = 10.seconds

    # Validates a VAT number by checking with the VIES service
    def self.validate(number : String)
      return {valid: false} if number.nil? || number.empty? || number.size < 3

      country_code = number[0..1]
      vat_number = number[2..-1]

      send_request(country_code, vat_number)
    end

    # Determines if VAT should be charged based on origin country and VAT number
    def self.charge_vat?(origin_country : String, number : String)
      return false if number.nil? || number.empty?

      Europe::Vat::Format::VAT_REGEX.keys.includes?(origin_country.to_s) ||
        Europe::Vat::Format::VAT_REGEX.keys.includes?(number[0..1])
    end

    # Sends a SOAP request to the VIES VAT validation service
    def self.send_request(country_code : String, number : String)
      # Default response with all fields nil and valid: false
      result = {
        valid: false,
        country_code: nil,
        vat_number: nil,
        request_date: nil,
        name: nil,
        address: nil,
      }

      begin
        # Create SOAP request body
        body = <<-XML
          <soapenv:Envelope
          xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:urn="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
            <soapenv:Header/>
            <soapenv:Body>
               <urn:checkVat>
                  <urn:countryCode>#{country_code}</urn:countryCode>
                  <urn:vatNumber>#{number}</urn:vatNumber>
               </urn:checkVat>
            </soapenv:Body>
          </soapenv:Envelope>
        XML

        # Set up HTTP client with timeout
        client = HTTP::Client.new(URI.parse(URL))
        client.connect_timeout = HTTP_TIMEOUT
        client.read_timeout = HTTP_TIMEOUT

        # Send request
        response = client.post(URI.parse(URL).path, headers: HEADERS, body: body)

        # Check for successful response
        if response.success?
          # Parse XML response using XML parser instead of regex
          xml = XML.parse(response.body)

          # Extract values using proper XML parsing
          # Define namespaces for XPath-like navigation
          ns_prefix = "ns2:"

          # Extract values using safer methods
          valid_element = extract_xml_element(response.body, "#{ns_prefix}valid")
          country_code_element = extract_xml_element(response.body, "#{ns_prefix}countryCode")
          vat_number_element = extract_xml_element(response.body, "#{ns_prefix}vatNumber")
          request_date_element = extract_xml_element(response.body, "#{ns_prefix}requestDate")
          name_element = extract_xml_element(response.body, "#{ns_prefix}name")
          address_element = extract_xml_element(response.body, "#{ns_prefix}address")

          # Update result with extracted values
          result = {
            valid: valid_element == "true",
            country_code: country_code_element,
            vat_number: vat_number_element,
            request_date: request_date_element,
            name: name_element,
            address: address_element,
          }
        else
          puts "VAT validation request failed: HTTP #{response.status_code}"
        end
      rescue ex : Exception
        puts "Error during VAT validation: #{ex.message}"
      ensure
        client.try &.close
      end

      result
    end

    # Helper method to extract element content from XML string
    private def self.extract_xml_element(xml_string : String, element_name : String)
      match = /<#{element_name}>(.*?)<\/#{element_name}>/.match(xml_string)
      match.try &.[1]
    end
  end
end
