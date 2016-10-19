import ceylon.file { temporaryDirectory, lines }
import ceylon.test { test, assertEquals }

shared test void testLines() {
    try (file = temporaryDirectory.TemporaryFile(null, null)) {
        try (writer = file.Overwriter()) {
            writer.writeLine("Testing...\n2\n3");
        }
        assertEquals(lines(file), ["Testing...","2","3"]);
    }
}

shared test void testLinesEmpty() {
    try (file = temporaryDirectory.TemporaryFile(null, null)) {
        assertEquals(lines(file), []);
    }
}
