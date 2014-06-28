import ceylon.test { ... }
import ceylon.unicode { ... }
import java.lang{
    JSystem = System { 
        jgetSystemProperty=getProperty 
    }
}
test void testUnicodeVersion() {
    String jreVersion = jgetSystemProperty("java.version");
    if (jreVersion.startsWith("1.7")) {
        assertEquals("6.0.0", unicodeVersion);
    } else if (jreVersion.startsWith("1.8")) {
        assertEquals("6.2.0", unicodeVersion);
    } else {
        throw AssertionError("new unicode version supported and not tested yet");
    }
}

test void testCharacterName() {
    assertEquals("LATIN CAPITAL LETTER A", characterName('A'));
    try {
        characterName('\{#0010FFFF}');
        fail();
    } catch (Exception e) {
        assertEquals("Invalid codepoint 1114111", e.message);
    }
}

test void testGeneralCategory() {
    assertEquals(letterUppercase, generalCategory('A'));
    assertEquals(separatorSpace, generalCategory(' '));
    assertEquals(numberDecimalDigit, generalCategory('\{ARABIC-INDIC DIGIT ONE}'));
}

test void testDirectionality() {
    assertEquals(leftToRight, directionality('A'));
    assertEquals(europeanNumber, directionality('1'));
    assertEquals(paragraphSeparator, directionality('\n'));
    assertEquals(arabicNumber, directionality('\{ARABIC-INDIC DIGIT ONE}'));
}