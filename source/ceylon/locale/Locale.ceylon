import ceylon.collection {
    HashMap
}
import ceylon.language.meta.declaration {
    Module
}

shared sealed class Language(tag, 
    languageCode, countryCode, variant, 
    displayName, 
    displayLanguage, displayCountry, displayVariant) {
    
    shared String languageCode;
    shared String? countryCode;
    shared String tag;
    shared String? variant;
    shared String displayName;
    shared String displayLanguage;
    shared String? displayCountry;
    shared String? displayVariant;
    
    string=>tag;
}

shared sealed class Formats(
    shortDateFormat = "d/MM/yy", 
    mediumDateFormat = "dd/MM/yyyy", 
    longDateFormat = "d MMMM yyyy", 
    shortTimeFormat = "HH:mm", 
    mediumTimeFormat = "HH:mm:ss", 
    longTimeFormat = "HH:mm:ss z", 
    integerFormat = "###0", 
    floatFormat = "###0.###", 
    percentageFormat = "###0%", 
    currencyFormat = "¤###0.###") {
    
    shared String shortDateFormat;
    shared String mediumDateFormat;
    shared String longDateFormat;
    
    shared String shortTimeFormat;
    shared String mediumTimeFormat;
    shared String longTimeFormat;
    
    shared String integerFormat;
    shared String floatFormat;
    shared String percentageFormat;
    shared String currencyFormat;
    
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


shared sealed class Currency(String code, 
    shared String numericCode, 
    shared String displayName, 
    shared String symbol,
    shared Integer fractionalDigits) {
    string => code;
}

Module localeModule = `module ceylon.locale`;

Iterator<String?> columns(String line) 
        => line.split(','.equals, true, false)
                .map(String.trimmed)
                .map((String col) => !col.empty then col)
                .iterator();

shared Locale currentLocale {
    assert (exists loc = locale(system.locale));
    return loc;
}

shared Locale? locale(String tag) {
    value resource = 
            localeModule.resourceByPath("ceylon/locale/" + tag + ".txt");
    if (exists resource) {
        value lines = resource.textContent()
                .split('\n'.equals, true, false)
                .iterator();
        
        assert (!is Finished firstLine = lines.next());
        value cols = columns(firstLine);
        assert (is String loc = cols.next(), loc==tag);
        assert (is String languageCode = cols.next());
        assert (is String? countryCode = cols.next());
        assert (is String? variant = cols.next());
        assert (is String displayName = cols.next());
        assert (is String displayLanguage = cols.next());
        assert (is String? displayCountry = cols.next());
        assert (is String? displayVariant = cols.next());
        assert (is String? currencyCode = cols.next());
        
        assert (!is Finished dateFormats = lines.next());
        value dateCols = columns(dateFormats);
        assert (is String shortDateFormat = dateCols.next());
        assert (is String mediumDateFormat = dateCols.next());
        assert (is String longDateFormat = dateCols.next());
        
        assert (!is Finished timeFormats = lines.next());
        value timeCols = columns(timeFormats);
        assert (is String shortTimeFormat = timeCols.next());
        assert (is String mediumTimeFormat = timeCols.next());
        assert (is String longTimeFormat = timeCols.next());
        
        assert (!is Finished numberFormats = lines.next());
        value numCols = columns(numberFormats);
        assert (is String integerFormat = numCols.next());
        assert (is String floatFormat = numCols.next());
        assert (is String percentageFormat = numCols.next());
        assert (is String currencyFormat = numCols.next());
        
        assert (!is Finished blankLine1 = lines.next(), blankLine1.empty);
        
        value languages = HashMap<String,Language>();
        while (!is Finished langLine = lines.next(), !langLine.empty) {
            value langCols = columns(langLine);
            assert (is String langTag = langCols.next());
            assert (is String langLanguageCode = langCols.next());
            assert (is String? langCountryCode = langCols.next());
            assert (is String? langVariant = langCols.next());
            assert (is String langDisplayName = langCols.next());
            assert (is String langDisplayLanguage = langCols.next());
            assert (is String? langDisplayCountry = langCols.next());
            assert (is String? langDisplayVariant = langCols.next());
            languages.put(langTag, 
                Language {
                    tag = langTag;
                    languageCode = langLanguageCode;
                    countryCode = langCountryCode;
                    variant = langVariant;
                    displayName = langDisplayName;
                    displayLanguage = langDisplayLanguage;
                    displayCountry = langDisplayCountry;
                    displayVariant = langDisplayVariant;
                });
        }
        
        value currencies = HashMap<String,Currency>();
        while (!is Finished currencyLine = lines.next(), !currencyLine.empty) {
            value langCols = columns(currencyLine);
            assert (is String code = langCols.next());
            assert (is String numericCode = langCols.next());
            assert (is String name = langCols.next());
            assert (is String symbol = langCols.next());
            assert (is String digits = langCols.next(), 
                exists fractionalDigits=parseInteger(digits));
            currencies.put(code,
                Currency {
                    code = code;
                    numericCode = numericCode;
                    displayName = name;
                    symbol = symbol;
                    fractionalDigits = fractionalDigits;
                });
        }
        
        return Locale {
            Language {
                tag = tag;
                languageCode = languageCode;
                countryCode = countryCode;
                variant = variant;
                displayName = displayName;
                displayLanguage = displayLanguage;
                displayCountry = displayCountry;
                displayVariant = displayVariant;
            };
            Formats {
                shortDateFormat = shortDateFormat;
                mediumDateFormat = mediumDateFormat;
                longDateFormat = longDateFormat;
                shortTimeFormat = shortTimeFormat;
                mediumTimeFormat = mediumTimeFormat;
                longTimeFormat = longTimeFormat;
                integerFormat = integerFormat;
                floatFormat = floatFormat;
                percentageFormat = percentageFormat;
                currencyFormat = currencyFormat;
            };
            languages = languages;
            currencies = currencies;
            currencyCode = currencyCode;
        };
    }
    else {
        return null;
    }
}