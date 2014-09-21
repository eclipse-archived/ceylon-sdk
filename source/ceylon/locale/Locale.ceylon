import ceylon.collection {
    HashMap
}
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
    languages, currencies, currencyCode=null) {
    
    "The language of this locale."
    shared Language language;
    
    "Localized date, time, currency, and numeric formats
     for this locale."
    shared Formats formats;
    
    "Localized representations of other languages."
    shared HashMap<String,Language> languages;
    
    "Localized representations of other currencies."
    shared Map<String,Currency> currencies;
    
    String? currencyCode;
    
    "The currency of this locale."
    shared Currency? currency {
        if (exists currencyCode) {
            return currencies[currencyCode];
        }
        else {
            return null;
        }
    }
    
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
        
        value languageAndCurrency = parseLanguage(lines, tag);
        
        return Locale {
            language = languageAndCurrency[0];
            currencyCode = languageAndCurrency[1];
            formats = parseFormats(lines);
            languages = parseLanguages(lines);
            currencies = parseCurrencies(lines);
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
