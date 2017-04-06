import java.lang {
    Types {
        nativeString
    },
    JSystem=System {
        jgetSystemProperty=getProperty
    },
    JChar=Character {
        getName,
        getType,
        getDirectionality,
        dirARABIC_NUMBER=directionalityArabicNumber,
        dirBOUNDARY_NEUTRAL=directionalityBoundaryNeutral,
        dirCOMMON_NUMBER_SEPARATOR=directionalityCommonNumberSeparator,
        dirEUROPEAN_NUMBER=directionalityEuropeanNumber,
        dirEUROPEAN_NUMBER_SEPARATOR=directionalityEuropeanNumberSeparator,
        dirEUROPEAN_NUMBER_TERMINATOR=directionalityEuropeanNumberTerminator,
        dirLEFT_TO_RIGHT=directionalityLeftToRight,
        dirLEFT_TO_RIGHT_EMBEDDING=directionalityLeftToRightEmbedding,
        dirLEFT_TO_RIGHT_OVERRIDE=directionalityLeftToRightOverride,
        dirNONSPACING_MARK=directionalityNonspacingMark,
        dirOTHER_NEUTRALS=directionalityOtherNeutrals,
        dirPARAGRAPH_SEPARATOR=directionalityParagraphSeparator,
        dirPOP_DIRECTIONAL_FORMAT=directionalityPopDirectionalFormat,
        dirRIGHT_TO_LEFT=directionalityRightToLeft,
        dirRIGHT_TO_LEFT_ARABIC=directionalityRightToLeftArabic,
        dirRIGHT_TO_LEFT_EMBEDDING=directionalityRightToLeftEmbedding,
        dirRIGHT_TO_LEFT_OVERRIDE=directionalityRightToLeftOverride,
        dirSEGMENT_SEPARATOR=directionalitySegmentSeparator,
        dirUNDEFINED=directionalityUndefined,
        dirWHITESPACE=directionalityWhitespace,
        gcCOMBINING_SPACING_MARK=combiningSpacingMark,
        gcCONNECTOR_PUNCTUATION=connectorPunctuation,
        gcCONTROL=control,
        gcCURRENCY_SYMBOL=currencySymbol,
        gcDASH_PUNCTUATION=dashPunctuation,
        gcDECIMAL_DIGIT_NUMBER=decimalDigitNumber,
        gcENCLOSING_MARK=enclosingMark,
        gcEND_PUNCTUATION=endPunctuation,
        gcFINAL_QUOTE_PUNCTUATION=finalQuotePunctuation,
        gcFORMAT=format,
        gcINITIAL_QUOTE_PUNCTUATION=initialQuotePunctuation,
        gcLETTER_NUMBER=letterNumber,
        gcLINE_SEPARATOR=lineSeparator,
        gcLOWERCASE_LETTER=lowercaseLetter,
        gcMATH_SYMBOL=mathSymbol,
        gcMODIFIER_LETTER=modifierLetter,
        gcMODIFIER_SYMBOL=modifierSymbol,
        gcNON_SPACING_MARK=nonSpacingMark,
        gcOTHER_LETTER=otherLetter,
        gcOTHER_NUMBER=otherNumber,
        gcOTHER_PUNCTUATION=otherPunctuation,
        gcOTHER_SYMBOL=otherSymbol,
        gcPARAGRAPH_SEPARATOR=paragraphSeparator,
        gcPRIVATE_USE=privateUse,
        gcSPACE_SEPARATOR=spaceSeparator,
        gcSTART_PUNCTUATION=startPunctuation,
        gcSURROGATE=surrogate,
        gcTITLECASE_LETTER=titlecaseLetter,
        gcUNASSIGNED=unassigned,
        gcUPPERCASE_LETTER=uppercaseLetter
    }
}
import java.text {
    BreakIterator {
        done,
        getSentenceInstance,
        getWordInstance,
        getCharacterInstance
    }
}
import java.util {
    Locale
}

"The version of the Unicode standard being used, or `null` 
 if this information was not available."
shared String? unicodeVersion {
    value jreVersion
            = jgetSystemProperty("java.version")
            else "";
    return if (jreVersion.startsWith("1.7")) then "6.0.0"
    else if (jreVersion.startsWith("1.8")) then "6.2.0"
    else null;
}

"Enumerates the *Directionalities* defined by the Unicode 
 specification."
shared abstract class Directionality(code)
        of arabicNumber 
         | boundaryNeutral
         | commonNumberSeparator
         | europeanNumber
         | europeanNumberSeparator
         | europeanNumberTerminator
         | leftToRight
         | leftToRightEmbedding
         | leftToRightOverride
         | nonspacingMark
         | otherNeutrals
         | paragraphSeparator
         | popDirectionalFormat
         | rightToLeft
         | rightToLeftArabic
         | rightToLeftEmbedding
         | rightToLeftOverride
         | segmentSeparator
         | undefined
         | whitespace {
    
    "The two character code assigned to this directionality 
     by the Unicode specification."
    shared String code;
    
    string => code;
    
}
shared object arabicNumber  
        extends Directionality("AN") {}
shared object boundaryNeutral  
        extends Directionality("BN") {}
shared object commonNumberSeparator  
        extends Directionality("CS") {}
shared object europeanNumber  
        extends Directionality("EN") {}
shared object europeanNumberSeparator  
        extends Directionality("ES") {}
shared object europeanNumberTerminator  
        extends Directionality("ET") {}
shared object leftToRight  
        extends Directionality("L") {}
shared object leftToRightEmbedding  
        extends Directionality("LRE") {}
shared object leftToRightOverride  
        extends Directionality("LRO") {}
shared object nonspacingMark  
        extends Directionality("NSM") {}
shared object otherNeutrals  
        extends Directionality("ON") {}
shared object paragraphSeparator  
        extends Directionality("B") {}
shared object popDirectionalFormat  
        extends Directionality("PDF") {}
shared object rightToLeft  
        extends Directionality("R") {}
shared object rightToLeftArabic  
        extends Directionality("AL") {}
shared object rightToLeftEmbedding  
        extends Directionality("RLE") {}
shared object rightToLeftOverride  
        extends Directionality("RLO") {}
shared object segmentSeparator  
        extends Directionality("S") {}
shared object undefined  
        extends Directionality("") {}
shared object whitespace  
        extends Directionality("WS") {}

"The directionality of the given character."
shared Directionality directionality(Character character) 
        => let (dir = getDirectionality(character.integer))
        // Take a guess about the likelihood of various 
        // directionalities
             if (dir == dirLEFT_TO_RIGHT) 
                then leftToRight
        else if (dir == dirWHITESPACE) 
                then whitespace
        else if (dir == dirPARAGRAPH_SEPARATOR) 
                then paragraphSeparator
        else if (dir == dirEUROPEAN_NUMBER) 
                then europeanNumber
        else if (dir == dirEUROPEAN_NUMBER_SEPARATOR) 
                then europeanNumberSeparator
        else if (dir == dirCOMMON_NUMBER_SEPARATOR) 
                then commonNumberSeparator
        else if (dir == dirEUROPEAN_NUMBER_TERMINATOR) 
                then europeanNumberTerminator
        else if (dir == dirRIGHT_TO_LEFT) 
                then rightToLeft
        else if (dir == dirARABIC_NUMBER) 
                then arabicNumber
        else if (dir == dirBOUNDARY_NEUTRAL) 
                then boundaryNeutral
        else if (dir == dirLEFT_TO_RIGHT_EMBEDDING) 
                then leftToRightEmbedding
        else if (dir == dirLEFT_TO_RIGHT_OVERRIDE) 
                then leftToRightOverride
        else if (dir == dirNONSPACING_MARK) 
                then nonspacingMark
        else if (dir == dirOTHER_NEUTRALS) 
                then otherNeutrals
        else if (dir == dirPOP_DIRECTIONAL_FORMAT) 
                then popDirectionalFormat
        else if (dir == dirRIGHT_TO_LEFT_ARABIC) 
                then rightToLeftArabic
        else if (dir == dirRIGHT_TO_LEFT_EMBEDDING) 
                then rightToLeftEmbedding
        else if (dir == dirRIGHT_TO_LEFT_OVERRIDE) 
                then rightToLeftOverride
        else if (dir == dirSEGMENT_SEPARATOR) 
                then segmentSeparator
        else if (dir == dirUNDEFINED) 
                then undefined
        // In theory we should never get here, but this seems  
        // better than throwing, or returning an optional type
        else undefined;

"Enumerates the major classes of *General Category* 
 defined by the Unicode specification."
shared abstract class GeneralCategory(code, description)
        of Letter | Mark | Number | Other 
         | Punctuation | Separator | Symbol {
    
    "The two character code used to refer to this General 
     Category in the Unicode specification, e.g. `Zs` for 
     the 'space separator' general category."
    shared String code;
    
    "A description of this general category."
    shared String description;
    
    string => code;
}

"Enumerates the general categories in the *Letter* major 
 class."
shared abstract class Letter(String code, String description)  
        of letterLowercase
         | letterModifier
         | letterOther
         | letterTitlecase
         | letterUppercase 
        extends GeneralCategory(code, description) {
}
"The General category for `Ll`"
shared object letterLowercase 
        extends Letter("Ll", "Letter, lowercase") {}
"The General category for `Lm`"
shared object letterModifier 
        extends Letter("Lm", "Letter, modifier") {}
"The General category for `Lo`"
shared object letterOther  
        extends Letter("Lo", "Letter, other") {}
"The General category for `Lt`"
shared object letterTitlecase  
        extends Letter("Lt", "Letter, titlecase") {}
"The General category for `Lu`"
shared object letterUppercase  
        extends Letter("Lu", "Letter, unassigned") {}

"Enumerates the general categories in the *Mark* major 
 class."
shared abstract class Mark(String code, String description)
        of markCombiningSpacing
         | markEnclosing
         | markNonspacing
        extends GeneralCategory(code, description) {
}
"The General category for `Mc`"
shared object markCombiningSpacing  
        extends Mark("Mc", "Mark, spacing combining") {}
"The General category for `Me`"
shared object markEnclosing  
        extends Mark("Me", "Mark, enclosing") {}
"The General category for `Mn`"
shared object markNonspacing  
        extends Mark("Mn", "Mark, nonspacing") {}

"Enumerates the general categories in the *Number* major 
 class."
shared abstract class Number(String code, String description)
        of numberDecimalDigit
         | numberLetter
         | numberOther
        extends GeneralCategory(code, description) {
}
"The General category for `Nd`"
shared object numberDecimalDigit  
        extends Number("Nd", "Number, decimal digit") {}
"The General category for `Nl`"
shared object numberLetter  
        extends Number("Nl", "Number, letter") {}
"The General category for `No`"
shared object numberOther  
        extends Number("No", "Number, other") {}

"Enumerates the general categories in the *Other* major 
 class."
shared abstract class Other(String code, String description)  
        of otherControl
         | otherFormat
         | otherPrivateUse
         | otherSurrogate
         | otherUnassigned
        extends GeneralCategory(code, description) {
}
"The General category for `Cc`"
shared object otherControl  
        extends Other("Cc", "Other, control") {}
"The General category for `Cf`"
shared object otherFormat  
        extends Other("Cf", "Other, format") {}
"The General category for `Co`"
shared object otherPrivateUse  
        extends Other("Co", "Control, private use") {}
"The General category for `Cs`"
shared object otherSurrogate  
        extends Other("Cs", "Other, surrogate") {}
"The General category for `Cn`"
shared object otherUnassigned  
        extends Other("Cn", "Other, not assigned") {}

"Enumerates the general categories in the *Punctuation* 
 major class."
shared abstract class Punctuation(String code, String description)
        of punctuationConnector
         | punctuationDash
         | punctuationClose
         | punctuationFinalQuote
         | punctuationInitialQuote
         | punctuationOther
         | punctuationOpen
        extends GeneralCategory(code, description) {
}
"The General category for `Pe`"
shared object punctuationClose  
        extends Punctuation("Pe", "Punctuation, close") {}
"The General category for `Pc`"
shared object punctuationConnector  
        extends Punctuation("Pc", "Punctuaton, connector") {}
"The General category for `Pd`"
shared object punctuationDash  
        extends Punctuation("Pd", "Punctuation, dash") {}
"The General category for `Pf`"
shared object punctuationFinalQuote  
        extends Punctuation("Pf", "Punctuation, final quote") {}
"The General category for `Pi`"
shared object punctuationInitialQuote  
        extends Punctuation("Pi", "Punctuation, initial quote") {}
"The General category for `Ps`"
shared object punctuationOpen  
        extends Punctuation("Ps", "Punctuation, open") {}
"The General category for `Po`"
shared object punctuationOther  
        extends Punctuation("Po", "Punctuation, other") {}

"Enumerates the general categories in the *Separator* major 
 class."
shared abstract class Separator(String code, String description) 
        of separatorLine
         | separatorParagraph
         | separatorSpace 
        extends GeneralCategory(code, description) {
}
"The General category for `Zl`"
shared object separatorLine  
        extends Separator("Zl", "Separator, line") {}
"The General category for `Zp`"
shared object separatorParagraph  
        extends Separator("Zp", "Space, paragraph") {}
"The General category for `Zs`"
shared object separatorSpace  
        extends Separator("Zs", "Separator, space") {}

"Enumerates the general categories in the *Symbol* major 
 class."
shared abstract class Symbol(String code, String description)
        of symbolCurrency
         | symbolMath
         | symbolModifier
         | symbolOther
        extends GeneralCategory(code, description) {
}
"The General category for `Sc`"
shared object symbolCurrency  
        extends Symbol("Sc", "Symbol, currency") {}
"The General category for `Sm`"
shared object symbolMath  
        extends Symbol("Sm", "Symbol, math") {}
"The General category for `Sk`"
shared object symbolModifier  
        extends Symbol("Sk", "Symbol, modifier") {}
"The General category for `So`"
shared object symbolOther  
        extends Symbol("So", "Symbol, other") {}

"Determine if the given integer [[code point|codePoint]] is
 assigned a Unicode character."
shared Boolean assigned(Integer codePoint) 
        => 0<=codePoint<=#10FFFF &&
            JChar.isDefined(codePoint);

"Determine if the given integer [[code point|codePoint]] is
 belongs to a Unicode Private Use Area."
shared Boolean privateUse(Integer codePoint)
        => #E000<=codePoint<=#F8FF || 
           #F0000<=codePoint<=#FFFFD ||
           #100000<=codePoint<=#10FFFD;

"The general category of the given character."
shared GeneralCategory generalCategory(Character character)
        => let (gc = getType(character.integer).byte)
             if (gc == gcCOMBINING_SPACING_MARK)
                then markCombiningSpacing
        else if (gc == gcCONNECTOR_PUNCTUATION) 
                then punctuationConnector 
        else if (gc == gcCONTROL) 
                then otherControl 
        else if (gc == gcCURRENCY_SYMBOL) 
                then symbolCurrency 
        else if (gc == gcDASH_PUNCTUATION) 
                then punctuationDash 
        else if (gc == gcDECIMAL_DIGIT_NUMBER) 
                then numberDecimalDigit 
        else if (gc == gcENCLOSING_MARK) 
                then markEnclosing 
        else if (gc == gcEND_PUNCTUATION) 
                then punctuationClose 
        else if (gc == gcFINAL_QUOTE_PUNCTUATION) 
                then punctuationFinalQuote 
        else if (gc == gcFORMAT) 
                then otherFormat 
        else if (gc == gcINITIAL_QUOTE_PUNCTUATION) 
                then punctuationInitialQuote 
        else if (gc == gcLETTER_NUMBER) 
                then numberLetter 
        else if (gc == gcLINE_SEPARATOR) 
                then separatorLine 
        else if (gc == gcLOWERCASE_LETTER) 
                then letterLowercase 
        else if (gc == gcMATH_SYMBOL) 
                then symbolMath 
        else if (gc == gcMODIFIER_LETTER) 
                then letterModifier 
        else if (gc == gcMODIFIER_SYMBOL) 
                then symbolModifier 
        else if (gc == gcNON_SPACING_MARK) 
                then markNonspacing 
        else if (gc == gcOTHER_LETTER) 
                then letterOther 
        else if (gc == gcOTHER_NUMBER) 
                then numberOther 
        else if (gc == gcOTHER_PUNCTUATION) 
                then punctuationOther 
        else if (gc == gcOTHER_SYMBOL) 
                then symbolOther 
        else if (gc == gcPARAGRAPH_SEPARATOR) 
                then separatorParagraph 
        else if (gc == gcPRIVATE_USE) 
                then otherPrivateUse 
        else if (gc == gcSPACE_SEPARATOR) 
                then separatorSpace 
        else if (gc == gcSTART_PUNCTUATION) 
                then punctuationOpen 
        else if (gc == gcSURROGATE) 
                then otherSurrogate 
        else if (gc == gcTITLECASE_LETTER) 
                then letterTitlecase 
        else if (gc == gcUNASSIGNED) 
                then otherUnassigned 
        else if (gc == gcUPPERCASE_LETTER) 
                then letterUppercase
        else otherUnassigned;

"The Unicode name of the given character."
shared String characterName(Character character) {
    /* TODO java.lang.Character.getName substitutes a ficticious name if the
       unicode DB doesn't specify one, what should we do about this?' */
    if (exists result = getName(character.integer)) {
        return result;
    }
    else {
        throw Exception("Invalid codepoint " + 
            character.integer.string);
    }
}

//shared Character uppercaseCharacter(Character character) 
//        => JChar.toUpperCase(character.integer).character;
//
//shared Character lowercaseCharacter(Character character) 
//        => JChar.toLowerCase(character.integer).character;

Locale locale(String tag)
        => Locale.forLanguageTag(tag);

"Convert the given [[string]] to uppercase according to the
 rules of the locale with the given [[language tag|tag]]."
shared String uppercase(
    "The string to convert to uppercase."
    String string,
    "The IETF BCP 47 language tag string of the locale." 
    String tag = system.locale) 
        => nativeString(string).toUpperCase(locale(tag));

"Convert the given [[string]] to lowercase according to the
 rules of the locale with the given [[language tag|tag]]."
shared String lowercase(
    "The string to convert to lowercase."
    String string,
    "The IETF BCP 47 language tag string of the locale." 
    String tag = system.locale) 
        => nativeString(string).toLowerCase(locale(tag));

"The graphemes contained in the given [[string|text]]. In
 general, a Unicode `String` contains fewer graphemes than
 codepoints."
shared {String*} graphemes(
    "The string"
    String text, 
    "The IETF BCP 47 language tag string of the locale." 
    String tag = system.locale) 
        => object satisfies {String*} {
    iterator() => object satisfies Iterator<String> {
        value breakIterator = 
                getCharacterInstance(locale(tag));
        breakIterator.setText(text);
        value str = nativeString(text); //BreakIterator indexes by Java char
        variable value start = breakIterator.first();
        shared actual String|Finished next() {
            value end = breakIterator.next();
            if (end==done) {
                return finished;
            }
            else {
                value result = str.substring(start, end);
                start = end;
                return result;
            }
        }
    };
};

"The words and punctuation contained in the given 
 [[string|text]], according to the rules of the given 
 [[locale|tag]]. Any non-whitespace character not contained 
 in a word is treated as a whole word. All whitespace 
 characters are discarded."
shared {String*} words(
    "The string"
    String text, 
    "The IETF BCP 47 language tag string of the locale." 
    String tag = system.locale) 
        => object satisfies {String*} {
    iterator() => object satisfies Iterator<String> {
        value breakIterator = 
                getWordInstance(locale(tag));
        breakIterator.setText(text);
        value str = nativeString(text); //BreakIterator indexes by Java char
        variable value start = breakIterator.first();
        shared actual String|Finished next() {
            value end = breakIterator.next();
            if (end==done) {
                return finished;
            }
            else {
                value result = str.substring(start, end);
                start = end;
                return result.every(Character.whitespace)
                    then next() else result;
            }
        }
    };
};

"The sentences contained in the given [[string|text]],
 according to the rules of the given [[locale|tag]].
 Whitespace is trimmed from the beginning and end of each
 sentence, but whitespace contained within the sentence is 
 not normalized."
shared {String*} sentences(
    "The string"
    String text, 
    "The IETF BCP 47 language tag string of the locale." 
    String tag = system.locale) 
        => object satisfies {String*} {
    iterator() => object satisfies Iterator<String> {
        value breakIterator = 
                getSentenceInstance(locale(tag));
        breakIterator.setText(text);
        value str = nativeString(text); //BreakIterator indexes by Java char
        variable value start = breakIterator.first();
        shared actual String|Finished next() {
            value end = breakIterator.next();
            if (end==done) {
                return finished;
            }
            else {
                value result = str.substring(start, end).trimmed;
                start = end;
                return result.empty 
                    then next() else result;
            }
        }
    };
};