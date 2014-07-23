import ceylon.file {
    current,
    Nil,
    createFileIfNil,
    File
}

import java.text {
    DateFormat {
        short=SHORT,
        medium=MEDIUM,
        long=LONG,
        ...
    },
    SimpleDateFormat,
    NumberFormat {
        ...
    },
    DecimalFormat
}
import java.util {
    Locale,
    Currency
}

String pattern(DateFormat|NumberFormat format) {
    if (is SimpleDateFormat format) {
        return format.toPattern();
    }
    else if (is DecimalFormat format) {
        return format.toPattern();
    }
    else {
        return "";
    }
}

shared void mine() {
    for (locale in Locale.availableLocales.array) {
        if (exists locale) {
            value fileName = "resource/ceylon/locale/" + 
                    locale.toLanguageTag() + ".txt";
            value path = current.childPath(fileName);
            assert (is Nil|File resource = path.resource);
            value file = createFileIfNil(resource);
            try (writer = file.Overwriter()) {
                value w = writer;
                void writeData({String*} values) {
                    w.writeLine(", ".join(values));
                }
            
                value currency = 
                        locale.country.size==2 
                then Currency.getInstance(locale);
                writeData {
                    locale.toLanguageTag(),
                    locale.language,
                    locale.country,
                    locale.variant,
                    locale.displayName,
                    locale.displayLanguage,
                    locale.displayCountry,
                    locale.displayVariant,
                    currency?.currencyCode else ""
                };
                writeData {
                    pattern(getDateInstance(short, locale)),
                    pattern(getDateInstance(medium, locale)),
                    pattern(getDateInstance(long, locale))
                };
                writeData {
                    pattern(getTimeInstance(short, locale)),
                    pattern(getTimeInstance(medium, locale)),
                    pattern(getTimeInstance(long, locale))
                };
                writeData {
                    pattern(getIntegerInstance(locale)),
                    pattern(getNumberInstance(locale)),
                    pattern(getPercentInstance(locale)),
                    pattern(getCurrencyInstance(locale))
                };
                writeData {};
                for (loc in Locale.availableLocales.array) {
                    if (exists loc) {
                        writeData { 
                            loc.toLanguageTag(),
                            loc.language,
                            loc.country,
                            loc.variant,
                            loc.getDisplayName(locale),
                            loc.getDisplayLanguage(locale),
                            loc.getDisplayCountry(locale),
                            loc.getDisplayVariant(locale)
                        };
                    }
                }
                writeData {};
                for (curr in Currency.availableCurrencies.toArray().array) {
                    if (is Currency curr) {
                        writeData {
                            curr.currencyCode,
                            curr.numericCode.string,
                            curr.getDisplayName(locale),
                            curr.getSymbol(locale),
                            curr.defaultFractionDigits.string
                        };
                    }
                }
            }
        }
    }
}