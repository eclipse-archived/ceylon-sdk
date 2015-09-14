"""This package contains parsers implementations for reading [[ceylon.time::Date]], 
   [[ceylon.time::Time]], [[ceylon.time::DateTime]], [[ceylon.time.timezone::TimeZone]], and
   [[ceylon.time.timezone::ZoneDateTime]] values from their [ISO 8601][1] formatted string 
   representations.
   
   The parser functions are [[parseDate]], [[parseTime]], [[parseDateTime]], [[parseTimeZone]],
   and [[parseZoneDateTime]].
   
   This package only contains parsers for reading `Date`, `Time`, `DateTime` and `Period` values from their 
   [[string representation|String]] forms. There are no formatters in this package, as all relevant types return 
   ISO 8601 formatted values as their `string` attribute.
   
   If you need more flexible, locale aware parsing and formatting facilities, look into `ceylon.locale` package.
   
   [1]: https://en.wikipedia.org/wiki/ISO_8601"""
by("Roland Tepp")

shared package ceylon.time.iso8601;