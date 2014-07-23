import ceylon.collection {
    HashMap
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

[Language,String?] parseLanguage(Iterator<String> lines, String tag) {
    
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
    
    return [Language {
        tag = tag;
        languageCode = languageCode;
        countryCode = countryCode;
        variant = variant;
        displayName = displayName;
        displayLanguage = displayLanguage;
        displayCountry = displayCountry;
        displayVariant = displayVariant;
    }, currencyCode];
}

HashMap<String,Language> parseLanguages(Iterator<String> lines) {
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
    return languages;
}