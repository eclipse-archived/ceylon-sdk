import ceylon.language.meta.model {
    Type,
    nothingType
}
import ceylon.test {
    test,
    assertEquals
}
import ceylon.wrapper_type {
    displayNameForType
}

test
shared void testDisplayNameForType() {
    void assertMe(Type<> type, String expectedDisplayName) {
        assertEquals(displayNameForType(type), expectedDisplayName);
    }

    assertMe(`String`, "String");
    assertMe(`String|Integer`, "String|Integer");
    assertMe(`Identifiable&Obtainable`, "Identifiable&Obtainable");
    assertMe(`Identifiable&Obtainable|String`, "Identifiable&Obtainable|String");
    assertMe(nothingType, "nothingType");
}
