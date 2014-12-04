import ceylon.test {
    test,
    assertEquals
}
import ceylon.time.timezone.parser {
    parseLinkLine
}
import ceylon.time.timezone.model {
    AliasId,
    RealId
}

shared test void parseSimpleLinkLine() {
    //Link    America/Curacao    America/Lower_Princes    # Sint Maarten
    variable [RealId, AliasId] link = parseLinkLine("Link    America/Curacao    America/Lower_Princes");
    assertEquals(link[0], "America/Curacao");
    assertEquals(link[1], "America/Lower_Princes");
    
    //Link America/Port_of_Spain America/Dominica
    link = parseLinkLine("Link America/Port_of_Spain America/Dominica");
    assertEquals(link[0], "America/Port_of_Spain");
    assertEquals(link[1], "America/Dominica");
}
