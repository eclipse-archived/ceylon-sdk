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
    assertEquals(Letter.uppercase, generalCategory('A'));
    assertEquals(Separator.space, generalCategory(' '));
    assertEquals(Number.decimalDigit, generalCategory('\{ARABIC-INDIC DIGIT ONE}'));
}

test void testDirectionality() {
    assertEquals(Directionality.leftToRight, directionality('A'));
    assertEquals(Directionality.europeanNumber, directionality('1'));
    assertEquals(Directionality.paragraphSeparator, directionality('\n'));
    assertEquals(Directionality.arabicNumber, directionality('\{ARABIC-INDIC DIGIT ONE}'));
}

test void testGraphemes() {
    String g = "\{DEVANAGARI LETTER DA}\{DEVANAGARI SIGN VIRAMA}\{DEVANAGARI LETTER DHA}";
    assert (graphemes(g).size==1);
    assert (exists first = graphemes(g).first);
    assert (first==g);
    assert (graphemes("XK̅C𝔻").size==4);
}