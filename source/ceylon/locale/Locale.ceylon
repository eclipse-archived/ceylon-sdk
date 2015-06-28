import ceylon.language.meta.declaration {
    Module,
    Package
}
import ceylon.collection {
    HashMap
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
    
    function path(Package component, String filename) 
            => "/" 
            + component.qualifiedName.replace(".", "/") 
            + "/" + filename;
    
    "Given a [[Module]] or [[Package]] and the name of a 
     resource bundle belonging to that package or module, 
     return a map of string keys to string values for this 
     locale.
     
     For example, suppose the system locale is `en-AU`, and 
     this code occurs in the module `hello.world`:
     
         value messages = systemLocale.messages(`module`, \"messages\");
         
     Then the [[Map]] `messages` will contain entries from 
     the file `/hello/world/messages_en_AU.properties` in 
     the resources of the module `hello.world`."
    shared Map<String,String> messages(
        Module|Package component, String name) {
        String filename 
                = name + "_" 
                + language.tag.replace("-", "_") 
                + ".properties";
        value resource =
            switch (component)
            case (is Module) 
                component.resourceByPath(filename)
            case (is Package)
                component.container
                    .resourceByPath(path(component, filename));
        value map = HashMap<String, String>();
        if (exists resource) {
            for (line in resource.textContent().lines) {
                if (exists index 
                        = line.firstOccurrence("=")) {
                    value [key, definition] 
                            = line.slice(index);
                    map.put(key.trimmed, 
                        definition.rest.trimmed);
                }
            }
        }
        return map;
    }
}

"Returns a [[Locale]] containing information about the
 locale with the given locale [[tag]]."
shared Locale? locale(String tag) {
    value filePath = tag + ".txt";
    if (exists resource = 
            localeModule.resourceByPath(filePath)) {
        value lines = 
                resource.textContent()
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
