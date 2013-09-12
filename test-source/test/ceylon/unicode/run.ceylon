import ceylon.test { ... }
import ceylon.unicode { ... }

void testUnicodeVersion() {
    assertEquals("6.0.0", unicodeVersion);
}

void testCharacterName() {
    assertEquals("LATIN CAPITAL LETTER A", characterName('A'));
    try {
        characterName('\{#0010FFFF}');
        fail();
    } catch (Exception e) {
        assertEquals("Invalid codepoint 1114111", e.message);
    }
}

void testGeneralCategory() {
    assertEquals(letterUppercase, generalCategory('A'));
    assertEquals(separatorSpace, generalCategory(' '));
    assertEquals(numberDecimalDigit, generalCategory('\{ARABIC-INDIC DIGIT ONE}'));
}

void testDirectionality() {
    assertEquals(leftToRight, directionality('A'));
    assertEquals(europeanNumber, directionality('1'));
    assertEquals(paragraphSeparator, directionality('\n'));
    assertEquals(arabicNumber, directionality('\{ARABIC-INDIC DIGIT ONE}'));
}

shared void run(){
    suite("ceylon.unicode",
    "unicodeVersion" -> testUnicodeVersion,
    "characterName" -> testCharacterName,
    "generalCategory" -> testGeneralCategory,
    "directionality" -> testDirectionality
    );
}
