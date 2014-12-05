import ceylon.test {
    test,
    assertEquals
}
import ceylon.time.timezone.parser {
    parseLinkLine
}

shared test void parseSimpleLinkLine1() => assertEquals {
    actual = parseLinkLine("Link    America/Curacao    America/Lower_Princes");
    expected = ["America/Curacao", "America/Lower_Princes"];
};

shared test void parseSimpleLinkLine2() => assertEquals {
    actual = parseLinkLine("Link America/Port_of_Spain America/Dominica");
    expected = ["America/Port_of_Spain", "America/Dominica"];
};
