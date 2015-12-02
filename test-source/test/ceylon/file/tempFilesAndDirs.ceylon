import ceylon.test {
    test,
    assertTrue,
    assertEquals
}
import ceylon.file {
    TemporaryFile,
    Path,
    File,
    Nil,
    TemporaryDirectory,
    Directory,
    lines
}

shared test void simpleTempFile() {
    Path path;
    try (file = TemporaryFile()) {
        path = file.path;
        assertTrue(path.resource is File, "The temporary file must exist");
    }
    assertTrue(path.resource is Nil, "The temporary file should have been deleted");
}

shared test void tempFilePrefixSuffix() {
    try (file = TemporaryFile("myprefix", "mysuffix")) {
        assertTrue(file.name.startsWith("myprefix"),
            "temp file must start with specified prefix");

        assertTrue(file.name.endsWith("mysuffix"),
            "temp file must end with specified suffix");
    }
}

shared test void simpleTempDirectory() {
    Path path;
    try (dir = TemporaryDirectory()) {
        path = dir.path;
        assertTrue(path.resource is Directory, "The temporary dir must exist");
    }
    assertTrue(path.resource is Nil, "The temporary dir should have been deleted");
}

shared test void tempDirectoryPrefix() {
    try (dir = TemporaryDirectory("myprefix")) {
        assertTrue(dir.name.startsWith("myprefix"),
            "temp dir must start with specified prefix");
    }
}

shared test void tempDirAndFile() {
    try (dir = TemporaryDirectory()) {
        try (file = TemporaryFile { parentDirectory = dir; }) {
            try (writer = file.Overwriter()) {
                writer.writeLine("Testing...");
            }
            assert (exists line = lines(file).first);
            assertEquals(line, "Testing...");
        }
    }
}
