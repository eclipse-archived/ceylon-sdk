import ceylon.language.meta.declaration {
    Module
}

"Aggregates localized information associated with a certain 
 locale, including:
 
 - the local [[language]],
 - the local [[currency]],
 - localized date, time, currency, and numeric [[formats]],
 - local representations of other [[languages]] and
   [[currencies]]."
shared sealed class Locale(language, formats, 
    languages, currencies, currencyCode=null,
    lowercaseMappings = emptyMap, 
    uppercaseMappings = emptyMap) {
    
    "The language of this locale."
    shared Language language;
    
    "Localized date, time, currency, and numeric formats
     for this locale."
    shared Formats formats;
    
    "Localized representations of other languages."
    shared Map<String,Language> languages;
    
    "Localized representations of other currencies."
    shared Map<String,Currency> currencies;
    
    "Localized mappings of uppercase characters to lowercase."
    Map<Character,String> lowercaseMappings;
    
    "Localized mappings of lowercase characters to uppercase."
    Map<Character,String> uppercaseMappings;
    
    String? currencyCode;
    
    "The currency of this locale."
    shared Currency? currency 
            => if (exists currencyCode) 
            then currencies[currencyCode] 
            else null;
    
    "A string with the characters of the given string
     converted to uppercase according to the rules of this
     locale."
    shared String uppercase(String string)
            => uppercaseMappings.fold(string)((str, mapping) 
            => str.replace(mapping.key.string, mapping.item))
                .uppercased;
    
    "A string with the characters of the given string
     converted to lowercase according to the rules of this
     locale."
    shared String lowercase(String string) 
            => lowercaseMappings.fold(string)((str, mapping) 
            => str.replace(mapping.key.string, mapping.item))
                .lowercased;
    
    string => language.string;
}

"Returns a [[Locale]] containing information about the
 locale with the given locale [[tag]]."
shared Locale? locale(String tag) {
    value filePath = tag + ".txt";
    if (exists resource = 
            localeModule.resourceByPath(filePath)) {
        value lines = resource.textContent()
                .lines.iterator();
        
        value [language,currency] 
                = parseLanguage(lines, tag);
        
        return Locale {
            language = language;
            currencyCode = currency;
            formats = parseFormats(lines);
            languages = parseLanguages(lines);
            currencies = parseCurrencies(lines);
            lowercaseMappings = parseCaseMappings(lines);
            uppercaseMappings = parseCaseMappings(lines);
        };
    }
    else {
        return null;
    }
}

"Returns a [[Locale]] containing information about the
 locale of the current system."
see (`value system.locale`)
shared Locale systemLocale {
    "locale data for current locale must exist"
    assert (exists systemLocaleCache);
    return systemLocaleCache;
}

Locale? systemLocaleCache = locale(system.locale);

Module localeModule = `module ceylon.locale`;
