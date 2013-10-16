import ceylon.test { ... }
import ceylon.unicode { ... }

test void testUnicodeVersion() {
    assertEquals("6.0.0", unicodeVersion);
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

shared void run(){
    value result = createTestRunner([`module test.ceylon.unicode`]).run();
    print(result);
}