import ceylon.time.iso8601 { parseISOTimeZone = parseTimeZone, ParserError }

"Timezone offset parser based on ISO-8601, currently it accepts the following time zone offset patterns:
   &plusmn;`[hh]:[mm]`, &plusmn;`[hh][mm]`, and &plusmn;`[hh]`
 
 In addition, the special code `Z` is recognized as a shorthand for `+00:00`"
deprecated("This method has been moved to `ceylon.time.iso8601` package and 
            may be removed in future versions.")
shared <TimeZone|ParserError>(String) parseTimeZone = parseISOTimeZone;
