# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
## 0.1.27
  - Refactored Countries module for better maintainability and type safety
  - Added Country class to represent country data with proper typing
  - Simplified the Reversed lookup functionality
  - Improved code organization and documentation
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.26...v0.1.27)
## 0.1.26
  - Improved error handling in VAT rates retrieval
  - Fixed type consistency between FALLBACK_RATES and extract_rates
  - Enhanced HTML parsing robustness in VAT rates extraction
  - Improved VAT number validation with better type handling
  - Added proper error handling for HTTP requests
  - Removed UK from VAT rates
  - Fixed deprecated HTTP timeout methods using Time::Span
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.25...v0.1.26)
## 0.1.25
  - Added support for new Belgium VAT numbers
  - Updated to Crystal 1.15.1
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.24...v0.1.25)
## 0.1.24
  - Updated Estonian Tax rate to 22%
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.23...v0.1.24)
## 0.1.23
  - Added fallback for VAT rates when they can't be retrieved from the EU service
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.22...v0.1.23)
## 0.1.22
  - Fixed parsing of VAT number validation request
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.21...v0.1.22)
## 0.1.21
  - Updated to Crystal 1.5.0
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.20...v0.1.21)

## 0.1.20
  - Updated to Crystal 1.3.2
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.19...v0.1.20)
## 0.1.19
  - Updated to Crystal 1.2.0
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.18...v0.1.19)
## 0.1.18
  - Added Estonia and Lithuania to Eurozone and changed their currency to EUR.
  - Fixed full changelog links
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.17...v0.1.18)
## 0.1.17
  - Fixed bug in `charge_vat?` which wasn't checking origin country
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.16...v0.1.17)

## 0.1.16
  - Updated to Crystal 1.0.0
  - Removed all UK/GB logic from VAT number validations
  - Removed development dependencies
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.15...v0.1.16)

## 0.1.15
  - Changed Slovak Republic to Slovakia in country names
  - Updated outdated endpoint for VAT rates, thanks to @firstpromoter
  - Added changelog file
  - Removed tests related to UK based VAT validations
  - Updated to Crystal 0.36.0
  - [Full Changelog](https://github.com/gem-shards/europe.cr/compare/v0.1.14...v0.1.15)
