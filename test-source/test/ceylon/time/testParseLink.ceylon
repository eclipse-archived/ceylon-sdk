import ceylon.test {
    assertEquals
}

void testParseLink() {
    //Link    America/Curacao    America/Lower_Princes    # Sint Maarten
    assertEquals(provider.links.get("America/Lower_Princes"), "America/Curacao");
    
    //Link America/Port_of_Spain America/Dominica
    assertEquals(provider.links.get("America/Dominica"), "America/Port_of_Spain");
}