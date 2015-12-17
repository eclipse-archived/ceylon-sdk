import ceylon.file {
    Path,
    File,
    Nil,
    Directory,
    lines,
    temporaryDirectory
}
import ceylon.test {
    test,
    assertTrue,
    assertEquals
}

shared test void simpleTempFile() {
    Path path;
    try (file = temporaryDirectory.TemporaryFile(null, null)) {
        path = file.path;
        assertTrue(path.resource is File, "The temporary file must exist");
    }
    assertTrue(path.resource is Nil, "The temporary file should have been deleted");
}

shared test void tempFilePrefixSuffix() {
    try (file = temporaryDirectory.TemporaryFile("myprefix", "mysuffix")) {
        assertTrue(file.name.startsWith("myprefix"),
            "temp file must start with specified prefix");

        assertTrue(file.name.endsWith("mysuffix"),
            "temp file must end with specified suffix");
    }
}

shared test void simpleTempDirectory() {
    Path path;
    try (dir = temporaryDirectory.TemporaryDirectory(null)) {
        path = dir.path;
        assertTrue(path.resource is Directory, "The temporary dir must exist");
    }
    assertTrue(path.resource is Nil, "The temporary dir should have been deleted");
}

shared test void tempDirectoryPrefix() {
    try (dir = temporaryDirectory.TemporaryDirectory("myprefix")) {
        assertTrue(dir.name.startsWith("myprefix"),
            "temp dir must start with specified prefix");
    }
}

shared test void tempDirAndFile() {
    try (dir = temporaryDirectory.TemporaryDirectory(null)) {
        try (file = dir.TemporaryFile(null, null)) {
            try (writer = file.Overwriter()) {
                writer.writeLine("Testing...");
            }
            assert (exists line = lines(file).first);
            assertEquals(line, "Testing...");
        }
    }
}
