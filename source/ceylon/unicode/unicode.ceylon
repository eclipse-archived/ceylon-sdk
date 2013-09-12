import java.lang{
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

"Enumerates character directionalities."
shared abstract class Directionality(code)
        of
        arabicNumber 
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
    Integer dir = getDirectionality(character.integer);
    
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

shared abstract class GeneralCategory(code, description) 
        of combiningSpacingMark
         | connectorPunctuation
         | control
         | currencySymbol
         | dashPunctuation
         | decimalDigitNumber
         | enclosingMark
         | endPunctuation
         | finalQuotePunctuation
         | format
         | initialQuotePunctuation
         | letterNumber
         | lineSeparator
         | lowercaseLetter
         | mathSymbol
         | modifierLetter
         | modifierSymbol
         // TODO Collides with the Directionality of the same name
         | nonspacingMark_
         | otherLetter
         | otherNumber
         | otherPunctuation
         | otherSymbol
         // TODO Collides with the Directionality of the same name
         | paragraphSeparator_
         | privateUse
         | spaceSeparator
         | startPunctuation
         | surrogate
         | titlecaseLetter
         | unassigned
         | uppercaseLetter {
    "The two character code used to refer to this general category in the 
     Unicode standard, e.g. `Zs` for the 'space separator' general category."
    shared String code;
    
    "A description of this general category."
    shared String description;
    
    Character first {
        value c = code[0];
        assert(exists c);
        return c;
    }
    "Whether this is a number category."
    shared Boolean number => first == 'N';
    "Whether this is a letter category."
    shared Boolean letter => first == 'L';
    "Whether this is a mark category."
    shared Boolean mark => first == 'M';
    "Whether this is a punctuation category."
    shared Boolean punctuation => first == 'P';
    "Whether this is a symbol category."
    shared Boolean symbol => first == 'S';
    "Whether this is a seperator category."
    shared Boolean separator => first == 'Z';
    "Whether this is an other category."
    shared Boolean other => first == 'C';
    
    shared actual String string = code;
}

shared object combiningSpacingMark extends GeneralCategory("Mc", "Mark, spacing combining"){}
shared object connectorPunctuation extends GeneralCategory("Pc", "Punctuaton, connector"){}
shared object control extends GeneralCategory("Cc", "Other, control"){}
shared object currencySymbol extends GeneralCategory("Sc", "Symbol, currency"){}
shared object dashPunctuation extends GeneralCategory("Pd", "Punctuation, dash"){}
shared object decimalDigitNumber extends GeneralCategory("Nd", "Number, decimal digit"){}
shared object enclosingMark extends GeneralCategory("Me", "Mark, enclosing"){}
shared object endPunctuation extends GeneralCategory("Pe", "Punctuation, end"){}
shared object finalQuotePunctuation extends GeneralCategory("Pf", "Punctuation, final quote"){}
shared object format extends GeneralCategory("Cf", "Control, format"){}
shared object initialQuotePunctuation extends GeneralCategory("Pi", "Punctuation, initial quote"){}
shared object letterNumber extends GeneralCategory("Nl", "Number, letter"){}
shared object lineSeparator extends GeneralCategory("Zl", "Separator, line"){}
shared object lowercaseLetter extends GeneralCategory("Ll", "Letter, lowercase"){}
shared object mathSymbol extends GeneralCategory("Sm", "Symbol, math"){}
shared object modifierLetter extends GeneralCategory("Lm", "Letter, modifier"){}
shared object modifierSymbol extends GeneralCategory("Sk", "Symbol, modifier"){}
shared object nonspacingMark_ extends GeneralCategory("Mn", "Mark, nonspacing"){}
shared object otherLetter extends GeneralCategory("Lo", "Letter, other"){}
shared object otherNumber extends GeneralCategory("No", "Number, other"){}
shared object otherPunctuation extends GeneralCategory("Po", "Punctuation, other"){}
shared object otherSymbol extends GeneralCategory("So", "Symbol, other"){}
shared object paragraphSeparator_ extends GeneralCategory("Zp", "Space, paragraph"){}
shared object privateUse extends GeneralCategory("Co", "Control, private use"){}
shared object spaceSeparator extends GeneralCategory("Zs", "Separator, space"){}
shared object startPunctuation extends GeneralCategory("Ps", "Punctuation, open"){}
shared object surrogate extends GeneralCategory("Cs", "Control, surrogate"){}
shared object titlecaseLetter extends GeneralCategory("Lt", "Letter, titlecase"){}
shared object unassigned extends GeneralCategory("Cn", "Other, not assigned"){}
shared object uppercaseLetter extends GeneralCategory("Lu", "Letter, unassigned"){}


"The general category of the given character"
shared GeneralCategory generalCategory(Character character) {
    Integer gc = getType(character.integer);
    if (gc == gcCOMBINING_SPACING_MARK) { return combiningSpacingMark; }
    else if (gc == gcCONNECTOR_PUNCTUATION) { return connectorPunctuation; }
    else if (gc == gcCONTROL) { return control; }
    else if (gc == gcCURRENCY_SYMBOL) { return currencySymbol; }
    else if (gc == gcDASH_PUNCTUATION) { return dashPunctuation; }
    else if (gc == gcDECIMAL_DIGIT_NUMBER) { return decimalDigitNumber; }
    else if (gc == gcENCLOSING_MARK) { return enclosingMark; }
    else if (gc == gcEND_PUNCTUATION) { return endPunctuation; }
    else if (gc == gcFINAL_QUOTE_PUNCTUATION) { return finalQuotePunctuation; }
    else if (gc == gcFORMAT) { return format; }
    else if (gc == gcINITIAL_QUOTE_PUNCTUATION) { return initialQuotePunctuation; }
    else if (gc == gcLETTER_NUMBER) { return letterNumber; }
    else if (gc == gcLINE_SEPARATOR) { return lineSeparator; }
    else if (gc == gcLOWERCASE_LETTER) { return lowercaseLetter; }
    else if (gc == gcMATH_SYMBOL) { return mathSymbol; }
    else if (gc == gcMODIFIER_LETTER) { return modifierLetter; }
    else if (gc == gcMODIFIER_SYMBOL) { return modifierSymbol; }
    else if (gc == gcNON_SPACING_MARK) { return nonspacingMark_; }
    else if (gc == gcOTHER_LETTER) { return otherLetter; }
    else if (gc == gcOTHER_NUMBER) { return otherNumber; }
    else if (gc == gcOTHER_PUNCTUATION) { return otherPunctuation; }
    else if (gc == gcOTHER_SYMBOL) { return otherSymbol; }
    else if (gc == gcPARAGRAPH_SEPARATOR) { return paragraphSeparator_; }
    else if (gc == gcPRIVATE_USE) { return privateUse; }
    else if (gc == gcSPACE_SEPARATOR) { return spaceSeparator; }
    else if (gc == gcSTART_PUNCTUATION) { return startPunctuation; }
    else if (gc == gcSURROGATE) { return surrogate; }
    else if (gc == gcTITLECASE_LETTER) { return titlecaseLetter; }
    else if (gc == gcUNASSIGNED) { return unassigned; }
    else if (gc == gcUPPERCASE_LETTER) { return uppercaseLetter; }
    return unassigned;
}

"The Unicode name of the character."
shared String name(Character character)
    /* TODO java.lang.Character.getName substitutes a ficticious name if the
       unicode DB doesn't specify one, what should we do about this?' */
    => getName(character.integer);
