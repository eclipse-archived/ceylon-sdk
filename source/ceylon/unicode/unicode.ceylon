/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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

import ceylon.unicode { Directionality { ... } }

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
shared class Directionality
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
    
    abstract new withCode(String code) {
        this.code=code;
    }
    
    shared new arabicNumber  
            extends withCode("AN") {}
    shared new boundaryNeutral  
            extends withCode("BN") {}
    shared new commonNumberSeparator  
            extends withCode("CS") {}
    shared new europeanNumber  
            extends withCode("EN") {}
    shared new europeanNumberSeparator  
            extends withCode("ES") {}
    shared new europeanNumberTerminator  
            extends withCode("ET") {}
    shared new leftToRight  
            extends withCode("L") {}
    shared new leftToRightEmbedding  
            extends withCode("LRE") {}
    shared new leftToRightOverride  
            extends withCode("LRO") {}
    shared new nonspacingMark  
            extends withCode("NSM") {}
    shared new otherNeutrals  
            extends withCode("ON") {}
    shared new paragraphSeparator  
            extends withCode("B") {}
    shared new popDirectionalFormat  
            extends withCode("PDF") {}
    shared new rightToLeft  
            extends withCode("R") {}
    shared new rightToLeftArabic  
            extends withCode("AL") {}
    shared new rightToLeftEmbedding  
            extends withCode("RLE") {}
    shared new rightToLeftOverride  
            extends withCode("RLO") {}
    shared new segmentSeparator  
            extends withCode("S") {}
    shared new undefined  
            extends withCode("") {}
    shared new whitespace  
            extends withCode("WS") {}

    string => code;
    
}


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
shared class Letter 
        of lowercase
         | modifier
         | other
         | titlecase
         | uppercase 
        extends GeneralCategory {

    abstract new with(String code, String description) 
        extends GeneralCategory(code, description) {}

    "The General category for `Ll`"
    shared new lowercase 
            extends with("Ll", "Letter, lowercase") {}
    "The General category for `Lm`"
    shared new modifier 
            extends with("Lm", "Letter, modifier") {}
    "The General category for `Lo`"
    shared new other  
            extends with("Lo", "Letter, other") {}
    "The General category for `Lt`"
    shared new titlecase  
            extends with("Lt", "Letter, titlecase") {}
    "The General category for `Lu`"
    shared new uppercase  
            extends with("Lu", "Letter, unassigned") {}

}

"Enumerates the general categories in the *Mark* major 
 class."
shared class Mark
        of combiningSpacing
         | enclosing
         | nonspacing
        extends GeneralCategory {
    
    abstract new with(String code, String description)
            extends GeneralCategory(code, description) {}

    "The General category for `Mc`"
    shared new combiningSpacing  
            extends with("Mc", "Mark, spacing combining") {}
    "The General category for `Me`"
    shared new enclosing  
            extends with("Me", "Mark, enclosing") {}
    "The General category for `Mn`"
    shared new nonspacing  
            extends with("Mn", "Mark, nonspacing") {}
}

"Enumerates the general categories in the *Number* major 
 class."
shared class Number
        of decimalDigit
         | letter
         | other
        extends GeneralCategory {

    abstract new with(String code, String description)
            extends GeneralCategory(code, description) {}

    "The General category for `Nd`"
    shared new decimalDigit  
            extends with("Nd", "Number, decimal digit") {}
    "The General category for `Nl`"
    shared new letter  
            extends with("Nl", "Number, letter") {}
    "The General category for `No`"
    shared new other  
            extends with("No", "Number, other") {}
}

"Enumerates the general categories in the *Other* major 
 class."
shared class Other  
        of control
         | format
         | privateUse
         | surrogate
         | unassigned
        extends GeneralCategory {

    abstract new with(String code, String description)
            extends GeneralCategory(code, description) {}

    "The General category for `Cc`"
    shared new control  
            extends with("Cc", "Other, control") {}
    "The General category for `Cf`"
    shared new format  
            extends with("Cf", "Other, format") {}
    "The General category for `Co`"
    shared new privateUse  
            extends with("Co", "Control, private use") {}
    "The General category for `Cs`"
    shared new surrogate  
            extends with("Cs", "Other, surrogate") {}
    "The General category for `Cn`"
    shared new unassigned  
            extends with("Cn", "Other, not assigned") {}

}

"Enumerates the general categories in the *Punctuation* 
 major class."
shared class Punctuation
        of connector 
         | dash
         | close
         | finalQuote
         | initialQuote
         | other
         | open
        extends GeneralCategory {

    abstract new with(String code, String description)
            extends GeneralCategory(code, description) {}


    "The General category for `Pe`"
    shared new close  
            extends with("Pe", "Punctuation, close") {}
    "The General category for `Pc`"
    shared new connector  
            extends with("Pc", "Punctuaton, connector") {}
    "The General category for `Pd`"
    shared new dash  
            extends with("Pd", "Punctuation, dash") {}
    "The General category for `Pf`"
    shared new finalQuote  
            extends with("Pf", "Punctuation, final quote") {}
    "The General category for `Pi`"
    shared new initialQuote  
            extends with("Pi", "Punctuation, initial quote") {}
    "The General category for `Ps`"
    shared new open  
            extends with("Ps", "Punctuation, open") {}
    "The General category for `Po`"
    shared new other  
            extends with("Po", "Punctuation, other") {}

}

"Enumerates the general categories in the *Separator* major 
 class."
shared class Separator 
        of line
         | paragraph
         | space 
        extends GeneralCategory {

    abstract new with(String code, String description)
            extends GeneralCategory(code, description) {}

    "The General category for `Zl`"
    shared new line  
            extends with("Zl", "Separator, line") {}
    "The General category for `Zp`"
    shared new paragraph  
            extends with("Zp", "Space, paragraph") {}
    "The General category for `Zs`"
    shared new space  
            extends with("Zs", "Separator, space") {}
}

"Enumerates the general categories in the *Symbol* major 
 class."
shared class Symbol
        of currency
         | math
         | modifier
         | other
        extends GeneralCategory {

    abstract new with(String code, String description)
            extends GeneralCategory(code, description) {}

    "The General category for `Sc`"
    shared new currency  
            extends with("Sc", "Symbol, currency") {}
    "The General category for `Sm`"
    shared new math  
            extends with("Sm", "Symbol, math") {}
    "The General category for `Sk`"
    shared new modifier  
            extends with("Sk", "Symbol, modifier") {}
    "The General category for `So`"
    shared new other  
            extends with("So", "Symbol, other") {}
}

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
                then Mark.combiningSpacing
        else if (gc == gcCONNECTOR_PUNCTUATION) 
                then Punctuation.connector 
        else if (gc == gcCONTROL) 
                then Other.control 
        else if (gc == gcCURRENCY_SYMBOL) 
                then Symbol.currency 
        else if (gc == gcDASH_PUNCTUATION) 
                then Punctuation.dash 
        else if (gc == gcDECIMAL_DIGIT_NUMBER) 
                then Number.decimalDigit 
        else if (gc == gcENCLOSING_MARK) 
                then Mark.enclosing 
        else if (gc == gcEND_PUNCTUATION) 
                then Punctuation.close 
        else if (gc == gcFINAL_QUOTE_PUNCTUATION) 
                then Punctuation.finalQuote 
        else if (gc == gcFORMAT) 
                then Other.format 
        else if (gc == gcINITIAL_QUOTE_PUNCTUATION) 
                then Punctuation.initialQuote 
        else if (gc == gcLETTER_NUMBER) 
                then Number.letter 
        else if (gc == gcLINE_SEPARATOR) 
                then Separator.line 
        else if (gc == gcLOWERCASE_LETTER) 
                then Letter.lowercase 
        else if (gc == gcMATH_SYMBOL) 
                then Symbol.math 
        else if (gc == gcMODIFIER_LETTER) 
                then Letter.modifier 
        else if (gc == gcMODIFIER_SYMBOL) 
                then Symbol.modifier 
        else if (gc == gcNON_SPACING_MARK) 
                then Mark.nonspacing 
        else if (gc == gcOTHER_LETTER) 
                then Letter.other 
        else if (gc == gcOTHER_NUMBER) 
                then Number.other 
        else if (gc == gcOTHER_PUNCTUATION) 
                then Punctuation.other 
        else if (gc == gcOTHER_SYMBOL) 
                then Symbol.other 
        else if (gc == gcPARAGRAPH_SEPARATOR) 
                then Separator.paragraph 
        else if (gc == gcPRIVATE_USE) 
                then Other.privateUse 
        else if (gc == gcSPACE_SEPARATOR) 
                then Separator.space 
        else if (gc == gcSTART_PUNCTUATION) 
                then Punctuation.open 
        else if (gc == gcSURROGATE) 
                then Other.surrogate 
        else if (gc == gcTITLECASE_LETTER) 
                then Letter.titlecase 
        else if (gc == gcUNASSIGNED) 
                then Other.unassigned 
        else if (gc == gcUPPERCASE_LETTER) 
                then Letter.uppercase
        else Other.unassigned;

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