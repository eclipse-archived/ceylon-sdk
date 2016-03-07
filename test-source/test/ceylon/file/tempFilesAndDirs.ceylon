import ceylon.file {
    Path,
    File,
    Nil,
    Directory,
    lines,
    temporaryDirectory,
    createZipFileSystem
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

shared test void tempDirAndFileInZip() {
    try (tempDir = temporaryDirectory.TemporaryDirectory(null)) {
        value zipPath = tempDir.path.childPath("testzip.zip");

        "a new temporary directory should be empty"
        assert (is Nil loc = zipPath.resource);

        value zipSystem = createZipFileSystem(loc);

        "zip file system should have a root path"
        assert (exists rootPath = zipSystem.rootPaths[0]);

        "the root path of a zip filesystem should be a Directory"
        assert (is Directory rootDir = rootPath.resource);

        Path tempDirInZipPath;
        Path tempFilePath;
        try (tempDirInZip = rootDir.TemporaryDirectory(null)) {
            tempDirInZipPath = tempDirInZip.path;
            try (tempFile = tempDirInZip.TemporaryFile(null, null)) {
                tempFilePath = tempFile.path;
                try (w = tempFile.Appender()) {
                    w.write("hello!");
                }
                assertEquals (lines(tempFile), ["hello!"],
                        "read from tempfile in zip fs");
            }
            assertTrue(tempFilePath.resource is Nil,
                    "temp file shouldn't exist after destroy()");
        }
        assertTrue(tempDirInZipPath.resource is Nil,
                "temp dir shouldn't exist after destroy()");
        zipSystem.close();
    }
}
