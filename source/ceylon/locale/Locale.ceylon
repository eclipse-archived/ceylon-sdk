import ceylon.collection {
    HashMap
}
import ceylon.language.meta.declaration {
    Module
}

shared sealed class Locale(language, formats, 
    languages, currencies, currencyCode=null) {
    
    shared Language language;
    
    shared Formats formats;
    
    shared HashMap<String,Language> languages;
    shared Map<String,Currency> currencies;
    
    String? currencyCode;
    
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

Locale? current = locale(system.locale);

shared Locale currentLocale {
    //TODO: cache it
    "locale data for current locale must exist"
    assert (exists current);
    return current;
}

shared Locale? locale(String tag) {
    value filePath = tag + ".txt";
    if (exists resource = 
            localeModule.resourceByPath(filePath)) {
        Iterator<String> lines = resource.textContent()
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

Module localeModule = `module ceylon.locale`;

{String?*} columns(String line) => line.split('|'.equals, true, false)
        .map(String.trimmed)
        .map((String col) => !col.empty then col);
