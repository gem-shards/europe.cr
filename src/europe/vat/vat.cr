require "http/client"

module Europe
  module Vat
    URL = "http://ec.europa.eu/taxation_customs/vies/" \
          "services/checkVatService"
    HEADERS = HTTP::Headers{"Content-Type" => "text/xml;charset=UTF-8",
                            "SOAPAction"   => ""}

    def self.validate(number : String)
      send_request(number[0..1], number[2..-1])
    end

    def self.charge_vat?(origin_country : String, number : String)
      return false if number.nil? || number.empty?
      if origin_country == number[0..1]
        true
      else
        Europe::Countries::COUNTRIES.keys.includes?(number[0..1])
      end
    end

    def self.send_request(country_code : String, number : String)
      body = <<-XML
        <soapenv:Envelope
        xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:urn="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
          <soapenv:Header/>
          <soapenv:Body>
             <urn:checkVat>
                <urn:countryCode>{COUNTRY_CODE}</urn:countryCode>
                <urn:vatNumber>{NUMBER}</urn:vatNumber>
             </urn:checkVat>
          </soapenv:Body>
        </soapenv:Envelope>
      XML
      body = body.gsub("{COUNTRY_CODE}", country_code)
      body = body.gsub("{NUMBER}", number)
      response = HTTP::Client.post(URL, headers: HEADERS, body: body)
      {
        valid:        /<valid>(.*)<\/valid>/.match(response.body).try &.[1] == "true",
        country_code: /<countryCode>(.*)<\/countryCode>/.match(response.body).try &.[1],
        vat_number:   /<vatNumber>(.*)<\/vatNumber>/.match(response.body).try &.[1],
        request_date: /<requestDate>(.*)<\/requestDate>/.match(response.body).try &.[1],
        name:         /<name>(.*)<\/name>/.match(response.body).try &.[1],
        address:      /<address>(.*)<\/address>/.match(response.body).try &.[1],
      }
    end
  end
end
