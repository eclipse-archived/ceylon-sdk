"Provides information about locale-specific information
 including:
 
 - language,
 - currency,
 - numeric formats, and
 - data/time formats.
 
 A locale is identified by a _locale tag_, as specified by
 IETF [BCP 47][], which contains:
 
 - a required _language code_, for example `en`, `es`, or 
   `ca`,
 - an optional _script code_, for example, `Latn`, or `Cyrl`, 
 - an optional country or _region code_, for example, `AU`, 
   `MX`, or `ES`, and
 - optionally, one or more _variant_ values, and
 - optionally, one or more _extensions_ as name/value pairs.
 
 Fields are separated by the character `-`. For example:
 `en`, `ca`, `en-AU`, `es-MX`.
 
 A [[Locale]] instance may be obtained for a given tag, by
 calling [[locale]]:
 
     assert (exists au = locale(\"en-AU\"));
 
 The [[system locale|systemLocale]] is also available.
 
 The `Locale` object provides information about the 
 [[Language]], [[Currency]] and [[Formats]] of the locale it 
 represents, along with information about the names of 
 [[other languages|Locale.languages]] and 
 [[currencies|Locale.currencies]] in that locale.
 
 [BCP 47]: http://tools.ietf.org/html/rfc4647"
module ceylon.locale "1.2.1" {
    shared import ceylon.collection "1.2.1";
    shared import ceylon.time "1.2.1";
}
