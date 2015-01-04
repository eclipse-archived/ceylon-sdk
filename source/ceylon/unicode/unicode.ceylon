import java.lang {
    JSystem = System {
        jgetSystemProperty=getProperty 
    },
    JChar = Character {
        getName,
        getType,
        getDirectionality,
        
        dirARABIC_NUMBER = DIRECTIONALITY_ARABIC_NUMBER,
        dirBOUNDARY_NEUTRAL = DIRECTIONALITY_BOUNDARY_NEUTRAL,
        dirCOMMON_NUMBER_SEPARATOR=DIRECTIONALITY_COMMON_NUMBER_SEPARATOR,
        dirEUROPEAN_NUMBER=DIRECTIONALITY_EUROPEAN_NUMBER,
        dirEUROPEAN_NUMBER_SEPARATOR=DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR,
        dirEUROPEAN_NUMBER_TERMINATOR=DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR,
        dirLEFT_TO_RIGHT=DIRECTIONALITY_LEFT_TO_RIGHT,
        dirLEFT_TO_RIGHT_EMBEDDING=DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING,
        dirLEFT_TO_RIGHT_OVERRIDE=DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE,
        dirNONSPACING_MARK=DIRECTIONALITY_NONSPACING_MARK,
        dirOTHER_NEUTRALS=DIRECTIONALITY_OTHER_NEUTRALS,
        dirPARAGRAPH_SEPARATOR=DIRECTIONALITY_PARAGRAPH_SEPARATOR,
        dirPOP_DIRECTIONAL_FORMAT=DIRECTIONALITY_POP_DIRECTIONAL_FORMAT,
        dirRIGHT_TO_LEFT=DIRECTIONALITY_RIGHT_TO_LEFT,
        dirRIGHT_TO_LEFT_ARABIC=DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC,
        dirRIGHT_TO_LEFT_EMBEDDING=DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING,
        dirRIGHT_TO_LEFT_OVERRIDE=DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE,
        dirSEGMENT_SEPARATOR=DIRECTIONALITY_SEGMENT_SEPARATOR,
        dirUNDEFINED=DIRECTIONALITY_UNDEFINED,
        dirWHITESPACE=DIRECTIONALITY_WHITESPACE,
        // General categories
        gcCOMBINING_SPACING_MARK = COMBINING_SPACING_MARK,
        gcCONNECTOR_PUNCTUATION = CONNECTOR_PUNCTUATION,
        gcCONTROL = CONTROL,
        gcCURRENCY_SYMBOL = CURRENCY_SYMBOL,
        gcDASH_PUNCTUATION = DASH_PUNCTUATION,
        gcDECIMAL_DIGIT_NUMBER = DECIMAL_DIGIT_NUMBER,
        gcENCLOSING_MARK = ENCLOSING_MARK,
        gcEND_PUNCTUATION = END_PUNCTUATION,
        gcFINAL_QUOTE_PUNCTUATION = FINAL_QUOTE_PUNCTUATION,
        gcFORMAT = FORMAT,
        gcINITIAL_QUOTE_PUNCTUATION = INITIAL_QUOTE_PUNCTUATION,
        gcLETTER_NUMBER = LETTER_NUMBER,
        gcLINE_SEPARATOR = LINE_SEPARATOR,
        gcLOWERCASE_LETTER = LOWERCASE_LETTER,
        gcMATH_SYMBOL = MATH_SYMBOL,
        gcMODIFIER_LETTER = MODIFIER_LETTER,
        gcMODIFIER_SYMBOL = MODIFIER_SYMBOL,
        gcNON_SPACING_MARK = NON_SPACING_MARK,
        gcOTHER_LETTER = OTHER_LETTER,
        gcOTHER_NUMBER = OTHER_NUMBER,
        gcOTHER_PUNCTUATION = OTHER_PUNCTUATION,
        gcOTHER_SYMBOL = OTHER_SYMBOL,
        gcPARAGRAPH_SEPARATOR = PARAGRAPH_SEPARATOR,
        gcPRIVATE_USE = PRIVATE_USE,
        gcSPACE_SEPARATOR = SPACE_SEPARATOR,
        gcSTART_PUNCTUATION = START_PUNCTUATION,
        gcSURROGATE = SURROGATE,
        gcTITLECASE_LETTER = TITLECASE_LETTER,
        gcUNASSIGNED = UNASSIGNED,
        gcUPPERCASE_LETTER = UPPERCASE_LETTER
    }
}
import ceylon.interop.java {
    javaString
}
import java.util {
    Locale
}
import java.text {
    BreakIterator
}

"The version of the Unicode standard being used, 
 or null if this information was not available."
shared String? unicodeVersion {
    String jreVersion = jgetSystemProperty("java.version");
    if (jreVersion.startsWith("1.7")) {
        return "6.0.0";
    } else if (jreVersion.startsWith("1.8")) {
        return "6.2.0";
    }
    return null;
}

"Enumerates the *Directionalities* defined in the 
 defined in the Unicode standard."
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
    "The two character code assigned to this directionality in the Unicode specification."
    shared String code;
    shared actual String string = code;
}
shared object arabicNumber extends Directionality("AN") {}
shared object boundaryNeutral extends Directionality("BN"){}
shared object commonNumberSeparator extends Directionality("CS"){}
shared object europeanNumber extends Directionality("EN"){}
shared object europeanNumberSeparator extends Directionality("ES"){}
shared object europeanNumberTerminator extends Directionality("ET"){}
shared object leftToRight extends Directionality("L"){}
shared object leftToRightEmbedding extends Directionality("LRE"){}
shared object leftToRightOverride extends Directionality("LRO"){}
shared object nonspacingMark extends Directionality("NSM"){}
shared object otherNeutrals extends Directionality("ON"){}
shared object paragraphSeparator extends Directionality("B"){}
shared object popDirectionalFormat extends Directionality("PDF"){}
shared object rightToLeft extends Directionality("R"){}
shared object rightToLeftArabic extends Directionality("AL"){}
shared object rightToLeftEmbedding extends Directionality("RLE"){}
shared object rightToLeftOverride extends Directionality("RLO"){}
shared object segmentSeparator extends Directionality("S"){}
shared object undefined extends Directionality(""){}
shared object whitespace extends Directionality("WS"){}

"The directionality of the given character."
shared Directionality directionality(Character character) {
    Byte dir = getDirectionality(character.integer);
    
    // Take a guess about the likelihood of various directionalities
         if (dir == dirLEFT_TO_RIGHT) { return leftToRight; }
    else if (dir == dirWHITESPACE) { return whitespace; }
    else if (dir == dirPARAGRAPH_SEPARATOR) { return paragraphSeparator; }
    else if (dir == dirEUROPEAN_NUMBER) { return europeanNumber; }
    else if (dir == dirEUROPEAN_NUMBER_SEPARATOR) { return europeanNumberSeparator; }
    else if (dir == dirCOMMON_NUMBER_SEPARATOR) { return commonNumberSeparator; }
    else if (dir == dirEUROPEAN_NUMBER_TERMINATOR) { return europeanNumberTerminator; }
    else if (dir == dirRIGHT_TO_LEFT) { return rightToLeft; }
    else if (dir == dirARABIC_NUMBER) { return arabicNumber; }
    else if (dir == dirBOUNDARY_NEUTRAL) { return boundaryNeutral; }
    else if (dir == dirLEFT_TO_RIGHT_EMBEDDING) { return leftToRightEmbedding; }
    else if (dir == dirLEFT_TO_RIGHT_OVERRIDE) { return leftToRightOverride; }
    else if (dir == dirNONSPACING_MARK) { return nonspacingMark; }
    else if (dir == dirOTHER_NEUTRALS) { return otherNeutrals; }
    else if (dir == dirPOP_DIRECTIONAL_FORMAT) { return popDirectionalFormat; }
    else if (dir == dirRIGHT_TO_LEFT_ARABIC) { return rightToLeftArabic; }
    else if (dir == dirRIGHT_TO_LEFT_EMBEDDING) { return rightToLeftEmbedding; }
    else if (dir == dirRIGHT_TO_LEFT_OVERRIDE) { return rightToLeftOverride; }
    else if (dir == dirSEGMENT_SEPARATOR) { return segmentSeparator; }
    else if (dir == dirUNDEFINED) { return undefined; }
    
    // In theory we should never get here, but this seems better than throwing, or returning an optional type
    return undefined;
}

"Enumerates the major classes of *General Category* 
 defined in the Unicode standard"
shared abstract class GeneralCategory(code, description)
        of Letter | Mark | Number | Other 
         | Punctuation | Separator | Symbol {
    "The two character code used to refer to this General Category in the 
     Unicode standard, e.g. `Zs` for the 'space separator' general category."
    shared String code;
    
    "A description of this general category."
    shared String description;
    
    string => code;
}

"Enumerates the general categories in the *Letter* major class"
shared abstract class Letter(String code, String description)  
        of letterLowercase
         | letterModifier
         | letterOther
         | letterTitlecase
         | letterUppercase 
        extends GeneralCategory(code, description){
}
"The General category for `Ll`"
shared object letterLowercase extends Letter("Ll", "Letter, lowercase"){}
"The General category for `Lm`"
shared object letterModifier extends Letter("Lm", "Letter, modifier"){}
"The General category for `Lo`"
shared object letterOther extends Letter("Lo", "Letter, other"){}
"The General category for `Lt`"
shared object letterTitlecase extends Letter("Lt", "Letter, titlecase"){}
"The General category for `Lu`"
shared object letterUppercase extends Letter("Lu", "Letter, unassigned"){}

"Enumerates the general categories in the *Mark* major class"
shared abstract class Mark(String code, String description)
        of markCombiningSpacing
         | markEnclosing
         | markNonspacing
        extends GeneralCategory(code, description){
}
"The General category for `Mc`"
shared object markCombiningSpacing extends Mark("Mc", "Mark, spacing combining"){}
"The General category for `Me`"
shared object markEnclosing extends Mark("Me", "Mark, enclosing"){}
"The General category for `Mn`"
shared object markNonspacing extends Mark("Mn", "Mark, nonspacing"){}

"Enumerates the general categories in the *Number* major class"
shared abstract class Number(String code, String description)
        of numberDecimalDigit
         | numberLetter
         | numberOther
        extends GeneralCategory(code, description){
}
"The General category for `Nd`"
shared object numberDecimalDigit extends Number("Nd", "Number, decimal digit"){}
"The General category for `Nl`"
shared object numberLetter extends Number("Nl", "Number, letter"){}
"The General category for `No`"
shared object numberOther extends Number("No", "Number, other"){}

"Enumerates the general categories in the *Other* major class"
shared abstract class Other(String code, String description)  
        of otherControl
         | otherFormat
         | otherPrivateUse
         | otherSurrogate
         | otherUnassigned
        extends GeneralCategory(code, description) {
}
"The General category for `Cc`"
shared object otherControl extends Other("Cc", "Other, control"){}
"The General category for `Cf`"
shared object otherFormat extends Other("Cf", "Other, format"){}
"The General category for `Co`"
shared object otherPrivateUse extends Other("Co", "Control, private use"){}
"The General category for `Cs`"
shared object otherSurrogate extends Other("Cs", "Other, surrogate"){}
"The General category for `Cn`"
shared object otherUnassigned extends Other("Cn", "Other, not assigned"){}

"Enumerates the general categories in the *Punctuation* major class"
shared abstract class Punctuation(String code, String description)
        of punctuationConnector
         | punctuationDash
         | punctuationClose
         | punctuationFinalQuote
         | punctuationInitialQuote
         | punctuationOther
         | punctuationOpen
        extends GeneralCategory(code, description){
}
"The General category for `Pe`"
shared object punctuationClose extends Punctuation("Pe", "Punctuation, close"){}
"The General category for `Pc`"
shared object punctuationConnector extends Punctuation("Pc", "Punctuaton, connector"){}
"The General category for `Pd`"
shared object punctuationDash extends Punctuation("Pd", "Punctuation, dash"){}
"The General category for `Pf`"
shared object punctuationFinalQuote extends Punctuation("Pf", "Punctuation, final quote"){}
"The General category for `Pi`"
shared object punctuationInitialQuote extends Punctuation("Pi", "Punctuation, initial quote"){}
"The General category for `Ps`"
shared object punctuationOpen extends Punctuation("Ps", "Punctuation, open"){}
"The General category for `Po`"
shared object punctuationOther extends Punctuation("Po", "Punctuation, other"){}

"Enumerates the general categories in the *Separator* major class"
shared abstract class Separator(String code, String description) 
        of separatorLine
         | separatorParagraph
         | separatorSpace 
        extends GeneralCategory(code, description){
}
"The General category for `Zl`"
shared object separatorLine extends Separator("Zl", "Separator, line"){}
"The General category for `Zp`"
shared object separatorParagraph extends Separator("Zp", "Space, paragraph"){}
"The General category for `Zs`"
shared object separatorSpace extends Separator("Zs", "Separator, space"){}

"Enumerates the general categories in the *Symbol* major class"
shared abstract class Symbol(String code, String description)
        of symbolCurrency
         | symbolMath
         | symbolModifier
         | symbolOther
        extends GeneralCategory(code, description){
}
"The General category for `Sc`"
shared object symbolCurrency extends Symbol("Sc", "Symbol, currency"){}
"The General category for `Sm`"
shared object symbolMath extends Symbol("Sm", "Symbol, math"){}
"The General category for `Sk`"
shared object symbolModifier extends Symbol("Sk", "Symbol, modifier"){}
"The General category for `So`"
shared object symbolOther extends Symbol("So", "Symbol, other"){}

"The general category of the given character"
shared GeneralCategory generalCategory(Character character) {
    Byte gc = getType(character.integer).byte;
         if (gc == gcCOMBINING_SPACING_MARK) { return markCombiningSpacing; }
    else if (gc == gcCONNECTOR_PUNCTUATION) { return punctuationConnector; }
    else if (gc == gcCONTROL) { return otherControl; }
    else if (gc == gcCURRENCY_SYMBOL) { return symbolCurrency; }
    else if (gc == gcDASH_PUNCTUATION) { return punctuationDash; }
    else if (gc == gcDECIMAL_DIGIT_NUMBER) { return numberDecimalDigit; }
    else if (gc == gcENCLOSING_MARK) { return markEnclosing; }
    else if (gc == gcEND_PUNCTUATION) { return punctuationClose; }
    else if (gc == gcFINAL_QUOTE_PUNCTUATION) { return punctuationFinalQuote; }
    else if (gc == gcFORMAT) { return otherFormat; }
    else if (gc == gcINITIAL_QUOTE_PUNCTUATION) { return punctuationInitialQuote; }
    else if (gc == gcLETTER_NUMBER) { return numberLetter; }
    else if (gc == gcLINE_SEPARATOR) { return separatorLine; }
    else if (gc == gcLOWERCASE_LETTER) { return letterLowercase; }
    else if (gc == gcMATH_SYMBOL) { return symbolMath; }
    else if (gc == gcMODIFIER_LETTER) { return letterModifier; }
    else if (gc == gcMODIFIER_SYMBOL) { return symbolModifier; }
    else if (gc == gcNON_SPACING_MARK) { return markNonspacing; }
    else if (gc == gcOTHER_LETTER) { return letterOther; }
    else if (gc == gcOTHER_NUMBER) { return numberOther; }
    else if (gc == gcOTHER_PUNCTUATION) { return punctuationOther; }
    else if (gc == gcOTHER_SYMBOL) { return symbolOther; }
    else if (gc == gcPARAGRAPH_SEPARATOR) { return separatorParagraph; }
    else if (gc == gcPRIVATE_USE) { return otherPrivateUse; }
    else if (gc == gcSPACE_SEPARATOR) { return separatorSpace; }
    else if (gc == gcSTART_PUNCTUATION) { return punctuationOpen; }
    else if (gc == gcSURROGATE) { return otherSurrogate; }
    else if (gc == gcTITLECASE_LETTER) { return letterTitlecase; }
    else if (gc == gcUNASSIGNED) { return otherUnassigned; }
    else if (gc == gcUPPERCASE_LETTER) { return letterUppercase; }
    return otherUnassigned;
}

"The Unicode name of the character."
shared String characterName(Character character) {
    /* TODO java.lang.Character.getName substitutes a ficticious name if the
       unicode DB doesn't specify one, what should we do about this?' */
    if (exists result = getName(character.integer)) {
        return result;
    }
    throw Exception("Invalid codepoint " + character.integer.string);
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
    "The IETF BCP 47 language tag string, or `null` to 
     perform the conversion according to the default locale." 
    String tag = system.locale) 
        => javaString(string).toUpperCase(locale(tag));

"Convert the given [[string]] to lowercase according to the
 rules of the locale with the given [[language tag|tag]]."
shared String lowercase(
    "The string to convert to lowercase."
    String string,
    "The IETF BCP 47 language tag string, or `null` to 
     perform the conversion according to the default locale." 
    String tag = system.locale) 
        => javaString(string).toLowerCase(locale(tag));

"The graphemes contained in the given [[string|text]]."
shared {String*} graphemes(
    "The string"
    String text, 
    "The IETF BCP 47 language tag string, or `null` to 
     perform the conversion according to the default locale." 
    String tag = system.locale) 
        => object satisfies {String*} {
    iterator() => object satisfies Iterator<String> {
        value breakIterator = 
                BreakIterator.getCharacterInstance(locale(tag));
        breakIterator.setText(text);
        variable value start = breakIterator.first();
        shared actual String|Finished next() {
                value end = breakIterator.next();
                if (end==BreakIterator.\iDONE) {
                    return finished;
                }
                value result = text[start..end-1];
                start = end;
                return result;
        }
    };
};