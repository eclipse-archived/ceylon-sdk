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

shared test void testReadBytes() {
    value str = "Testing...\n2\n3";
    value strBytes = str.collect((c) => c.integer.byte);
    try (file = temporaryDirectory.TemporaryFile(null, null)) {
        try (writer = file.Overwriter()) {
            writer.writeBytes(strBytes);
        }
        variable {Byte*} readBytes = {};
        try (reader = file.Reader()) {
            while (nonempty bytes = reader.readBytes(5)) {
                readBytes = readBytes.chain(bytes);
            }
        }
        value readStr = String(readBytes.map((b) => b.unsigned.character));
        assertEquals(readStr, str);
        assertEquals(readBytes.sequence(), strBytes);
    }
}
