/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    HashMap
}
import ceylon.language.meta.declaration {
    Module,
    Package
}

"Aggregates localized information associated with a certain 
 locale, including:
 
 - the local [[language]],
 - the local [[currency]],
 - localized date, time, currency, and numeric [[formats]],
 - local representations of other [[languages]] and
   [[currencies]].
 
 The locale also provides access to associated localized 
 message bundles via [[messages]]."
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
            => uppercaseMappings.fold(string, (str, mapping)
            => str.replace(mapping.key.string, mapping.item))
                .uppercased;
    
    "A string with the characters of the given string
     converted to lowercase according to the rules of this
     locale."
    shared String lowercase(String string) 
            => lowercaseMappings.fold(string, (str, mapping)
            => str.replace(mapping.key.string, mapping.item))
                .lowercased;
    
    string => language.string;
    
    function search(Module mod, String name) {
        function find(String tag) 
                => mod.resourceByPath(
                    name + tag + ".properties");
        
        value lang = language.languageCode;
        value country = language.countryCode;
        value variant = language.variant;
        if (exists country) {
            if (exists variant) {
                value tag = 
                        "_" + lang + 
                        "_" + country + 
                        "_" + variant;
                if (exists result = find(tag)) {
                     return result;
                }
            }
            value tag = 
                    "_" + lang + 
                    "_" + country;
            if (exists result = find(tag)) {
                return result;
            }
        }
        value tag = "_" + lang;
        if (exists result = find(tag)) {
            return result;
        }
        return find("");
    }
    
    function path(Package pack, String name) 
            => "/" + pack.qualifiedName.replace(".", "/")
            + "/" + name;
    
    
    
    "Given a [[Module]] or [[Package]] and the name of a 
     resource bundle belonging to that package or module, 
     return a map of string keys to string values for this 
     locale.
     
     For example, suppose the system locale is `en-AU`, and 
     this code occurs in the module `hello.world`:
     
         value messages = systemLocale.messages(`module`, \"Errors\");
         
     Then the returned map `messages` will contain 
     entries from a properties file in the resources of the 
     module `hello.world`. The following files will be 
     searched, in order:
     
     1. `/hello/world/Errors_en_AU.properties`
     2. `/hello/world/Errors_en.properties`
     3. `/hello/world/Errors.properties`
     
     If no properties file is found, the map with be empty."
    shared Map<String,String> messages(
        "The module to which the resource bundle belongs."
        Module|Package component, 
        "The name of the resource bundle, or `\"Messages\"`
         by default."
        String name = "Messages") {
        value resource =
            switch (component)
            case (Module)
                search(component, name)
            case (Package)
                component.container
                    .resourceByPath(path(component, name));
        value map = HashMap<String, String>();
        if (exists resource) {
            parsePropertiesFile { 
                textContent = resource.textContent(); 
                handleEntry = map.put;
            };
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
        
        let ([language,currency]
                = parseLanguage(lines, tag));
        
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
    "locale data for current locale ``system.locale`` must exist"
    assert (exists systemLocaleCache);
    return systemLocaleCache;
}

Locale? systemLocaleCache = locale(system.locale);

Module localeModule = `module`;
