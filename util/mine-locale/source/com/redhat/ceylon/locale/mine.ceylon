import ceylon.file {
    current,
    Nil,
    createFileIfNil,
    File
}

import java.lang {
    JString=String
}
import java.text {
    DateFormat {
        short=\iSHORT,
        medium=\iMEDIUM,
        long=\iLONG,
        ...
    },
    SimpleDateFormat,
    NumberFormat {
        ...
    },
    DecimalFormat,
    DateFormatSymbols
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

Boolean isLetter(Integer int) {
    try {
        value ch = int.character;
        return ch.letter;
    } catch (e) {
        return false;
    }
}

shared void mine() {
    for (locale in Locale.availableLocales.array) {
        if (exists locale, exists lang=locale.language, !lang.empty) {
            value fileName = "resource/ceylon/locale/" + 
                    locale.toLanguageTag() + ".txt";
            value path = current.childPath(fileName);
            assert (is Nil|File resource = path.resource);
            value file = createFileIfNil(resource);
            try (writer = file.Overwriter()) {
                value w = writer;
                void writeData({String*} values) {
                    w.writeLine(" | ".join(values));
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
                value dateFormatSymbols = DateFormatSymbols.getInstance(locale);
                writeData { 
                    dateFormatSymbols.amPmStrings.get(0).string,
                    dateFormatSymbols.amPmStrings.get(1).string
                };
                writeData { for (i in 0:12) dateFormatSymbols.months.get(i).string };
                writeData { for (i in 0:12) dateFormatSymbols.shortMonths.get(i).string };
                writeData { for (i in 1:7) dateFormatSymbols.weekdays.get(i).string };
                writeData { for (i in 1:7) dateFormatSymbols.shortWeekdays.get(i).string };
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
                    if (exists loc, exists lan=loc.language, !lan.empty) {
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
                writeData {};
                writeData {
                    for (ch in (0:#FFFF).filter(isLetter).map(Integer.character)) 
                    if (exists lc=JString(ch.string).toLowerCase(locale), 
                        lc!=ch.string.lowercased) 
                    "``ch``:``lc``"
                };
                writeData {
                    for (ch in (0:#FFFF).filter(isLetter).map(Integer.character)) 
                    if (exists uc = JString(ch.string).toUpperCase(locale), 
                        uc!=ch.string.uppercased) 
                    "``ch``:``uc``"
                };
            }
        }
    }
}