import ceylon.file {
    Nil,
    temporaryDirectory,
    Link,
    Directory,
    File
}
import ceylon.test {
    assertTrue,
    test,
    assertEquals
}

shared test void createAndResolveFileSymlink() {
    try (dir = temporaryDirectory.TemporaryDirectory(null)) {
        assert (is Nil targetNil = dir.path.childPath("myfile.txt").resource);
        value targetFile = targetNil.createFile();

        value linkPath = dir.path.childPath("mylink");
        assert (is Nil linkNil = linkPath.resource);
        value link = linkNil.createSymbolicLink(targetFile.path);

        assertTrue(linkPath.resource is Link, "The Link must exist");
        assertEquals(linkPath.resource.path, linkPath, "link path");
        assertEquals(link.linkedPath, targetFile.path, "linkedPath");
        assertTrue(link.linkedPath.resource is File, "linked resource is a File");

        link.delete();
        targetFile.delete();
    }
}

shared test void createAndResolveDirectorySymlink() {
    try (dir = temporaryDirectory.TemporaryDirectory(null)) {
        assert (is Nil targetNil = dir.path.childPath("mydir").resource);
        value targetDir = targetNil.createDirectory();

        value linkPath = dir.path.childPath("mylink");
        assert (is Nil linkNil = linkPath.resource);
        value link = linkNil.createSymbolicLink(targetDir.path);

        assertTrue(linkPath.resource is Link, "The Link must exist");
        assertEquals(linkPath.resource.path, linkPath, "link path");
        assertEquals(link.linkedPath, targetDir.path, "linkedPath");
        assertTrue(link.linkedPath.resource is Directory, "linked resource is a Directory");

        link.delete();
        targetDir.delete();
    }
}
