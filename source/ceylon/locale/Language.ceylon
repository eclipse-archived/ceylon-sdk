import ceylon.collection {
    HashMap
}

"Localized information about the language associated with 
 the given locale [[tag]]."
shared sealed class Language(tag, 
    languageCode, countryCode, variant, 
    displayName, 
    displayLanguage, displayCountry, displayVariant) {
    
    "The BCP 47 locale tag, for example, `en`, `ca`, `en-AU`, 
     or `es-MX`."
    shared String tag;

    "The language code, for example, `en`, or `es`."
    shared String languageCode;
    
    "The country or region code, for example, `AU`, or `MX`."
    shared String? countryCode;
    
    "Variant values, separated by underscores."
    shared String? variant;
    
    "A localized displayable name for this [[tag]], for
     example, `English`, `inglés`, `English (Australia)`, 
     or `inglés (Australia)`."
    shared String displayName;
    
    "A localized displayable name for the [[languageCode]],
     for example, `English`, or `inglés`."
    shared String displayLanguage;
    
    "A localized displayable name for the [[countryCode]],
     for example, `Australia`, or `México`."
    shared String? displayCountry;
    
    "A localized displayable name for the language 
     [[variant]]."
    shared String? displayVariant;
    
    string=>tag;
}

[Language,String?] parseLanguage(Iterator<String> lines, String tag) {
    
    assert (!is Finished firstLine = lines.next());
    value cols = columns(firstLine).iterator();
    assert (is String loc = cols.next(), loc==tag);
    assert (is String languageCode = cols.next());
    assert (is String? countryCode = cols.next());
    assert (is String? variant = cols.next());
    assert (is String displayName = cols.next());
    assert (is String displayLanguage = cols.next());
    assert (is String? displayCountry = cols.next());
    assert (is String? displayVariant = cols.next());
    assert (is String? currencyCode = cols.next());
    
    value language = Language {
        tag = tag;
        languageCode = languageCode;
        countryCode = countryCode;
        variant = variant;
        displayName = displayName;
        displayLanguage = displayLanguage;
        displayCountry = displayCountry;
        displayVariant = displayVariant;
    };
    return [language, currencyCode];
}

HashMap<Character,String> parseCaseMappings(Iterator<String> lines) {
    value caseMappings = HashMap<Character,String>();
    if (!is Finished line = lines.next(), !line.empty) {
        for (col in columns(line)) {
            assert (exists col, exists ch=col.first);
            caseMappings[ch] = col.spanFrom(2);
        }
    }
    return caseMappings;
}

HashMap<String,Language> parseLanguages(Iterator<String> lines) {
    value languages = HashMap<String,Language>();
    while (!is Finished langLine = lines.next(), 
           !langLine.empty) {
        value langCols = columns(langLine).iterator();
        assert (is String langTag = langCols.next());
        assert (is String langLanguageCode = langCols.next());
        assert (is String? langCountryCode = langCols.next());
        assert (is String? langVariant = langCols.next());
        assert (is String langDisplayName = langCols.next());
        assert (is String langDisplayLanguage = langCols.next());
        assert (is String? langDisplayCountry = langCols.next());
        assert (is String? langDisplayVariant = langCols.next());
        languages[langTag]
            = Language {
                tag = langTag;
                languageCode = langLanguageCode;
                countryCode = langCountryCode;
                variant = langVariant;
                displayName = langDisplayName;
                displayLanguage = langDisplayLanguage;
                displayCountry = langDisplayCountry;
                displayVariant = langDisplayVariant;
            };
    }
    return languages;
}