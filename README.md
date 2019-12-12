[![GitHub release](https://img.shields.io/github/release/VvanGemert/europe.cr.svg)](https://github.com/VvanGemert/europe.cr/releases)

# Europe.cr

This shard provides EU governmental data, extracted from various EU / EC websites. With this shard you can validate VAT numbers, retrieve VAT tax rates and currency exchange rates matched to the Euro. How to use this library is pretty straightforward and written below.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
  - [Validating VAT numbers](#validating-vat-numbers)
  - [Validate VAT number format](#validate-vat-number-format)
  - [Retrieving VAT rates for each EC/EU member](#retrieving-vat-rates-for-each-eceu-member)
  - [Retrieving currency exchange rates](#retrieving-currency-exchange-rates)
  - [Retrieving currency information](#retrieving-currency-information)
  - [Retrieving country information](#retrieving-country-information)
  - [Retrieving country information reversed](#retrieving-country-information-reversed)
- [Compatibility](#compatibility)
- [Todo](#todo)
- [Contributing](#contributing)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  europe.cr:
    github: VvanGemert/europe.cr
```

## Usage

First require the library;
```crystal
require "europe"
```

There are several calls you can make with this library. Below are a few examples
where this library can be used for.

### Validating VAT numbers
** Updated: Parameter now consists of one value.**
Call to validate VAT number (always starts with country code as specified in VIES)
```crystal
Europe::Vat.validate("GB440627467")
```
Response
```crystal
{ valid: true,
  country_code: "GB",
  vat_number: "440627467",
  request_date: "2018-06-16+02:00",
  name: "SKY PLC",
  address: nil }
```

### Validate VAT number format
Call
```crystal
Europe::Vat::Format.validate("NL123456789B01")
```
Response
```crystal
=> true
```


### Retrieving VAT rates for each EC/EU member
Call
```crystal
Europe::Vat::Rates.retrieve
```
Response
```crystal
{  "AT" => 20.0,
   "BE" => 21.0,
   "BG" => 20.0,
   "CY" => 19.0,
   "CZ" => 21.0,
   "DE" => 19.0,
   "DK" => 25.0,
   # etc...
```

### Retrieving currency exchange rates
Call
```crystal
Europe::Currency::ExchangeRates.retrieve
```
Response
```crystal
{  :date => 2018-06-15 00:00:00.0 UTC,
   :rates =>
   { "USD" => 1.099,
     "JPY" => 132.97,
     "BGN" => 1.9558,
     "CZK" => 27.022,
     "DKK" => 7.4614,
     "GBP" => 0.7252,
     # etc...
```

### Retrieving currency information
Call
```crystal
Europe::Currency::CURRENCIES
```
Response
```crystal
CURRENCIES = {
  EUR: { name: "Euro", symbol: "€", html: "&euro;" },
  BGN: { name: "Lev", symbol: "лв", html: "&#1083;&#1074;" },
  # etc...
```

### Retrieving country information
Call
```crystal
Europe::Countries::COUNTRIES
```
Response
```crystal
{
 BE:
  {name: "Belgium",
   source_name: "Belgique/België",
   official_name: "Kingdom of Belgium",
   tld: ".be",
   currency: "EUR",
   capital: "Brussels"},
 BG:
  {name: "Bulgaria",
   source_name: "България",
   official_name: "Republic of Bulgaria",
   tld: ".bg",
   currency: "BGN",
   capital: "Sofia"},
 # etc...
```

## Retrieving country information reversed
Call with optional parameters (name, currency, source_name, official_name, tld, currency and capital)
```crystal
Europe::Countries::Reversed.generate(:name)
```
Response
```crystal
{  "Belgium" => :BE,
   "Bulgaria" => :BG,
   "Czech Republic" => :CZ,
   "Denmark" => :DK,
   "Germany" => :DE,
   "Estonia" => :EE,
   # etc...
```

## Compatibility

This library is tested with the following Crystal versions on Linux and Mac OS X:

- 0.32.0

## Todo

- Generate docs
- Cleanup the code
- Eurostat integration (http://ec.europa.eu/eurostat/)
- ..

## Contributing

1. Fork it ( https://github.com/VvanGemert/europe.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [VvanGemert](https://github.com/VvanGemert) vvangemert - creator, maintainer
