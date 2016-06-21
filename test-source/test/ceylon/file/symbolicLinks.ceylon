import ceylon.file {
    Nil,
    temporaryDirectory,
    Directory,
    File,
    Path,
    parsePath
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

        assertTrue(linkPath.link exists, "The Link must exist");
        assertTrue(linkPath.resource is File,
            "resource returns File|Directory if possible");
        assertEquals(linkPath.link?.path, linkPath, "link path");
        assertEquals(linkPath.resource.path, linkPath,
            "link path using resource (don't resolve links when obtaining a resource)");
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

        assertTrue(linkPath.link exists, "The Link must exist");
        assertTrue(linkPath.resource is Directory,
            "resource returns File|Directory if possible");
        assertEquals(linkPath.link?.path, linkPath, "link path");
        assertEquals(linkPath.resource.path, linkPath,
            "link path using resource (don't resolve links when obtaining a resource)");
        assertEquals(link.linkedPath, targetDir.path, "linkedPath");
        assertTrue(link.linkedPath.resource is Directory, "linked resource is a Directory");

        link.delete();
        targetDir.delete();
    }
}

shared test void relativeLinkedPath() {
    // tmp/fileA
    // tmp/linkA -> fileA
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        value fileAPath = tmpDir.path.childPath("fileA");
        assert (is Nil nilFileA = fileAPath.resource);
        nilFileA.createFile();

        value linkAPath = tmpDir.path.childPath("linkA");
        assert (is Nil nilLinkA = linkAPath.resource);
        value linkA = nilLinkA.createSymbolicLink(parsePath("fileA"));

        assertEquals(linkA.linkedPath, fileAPath,
            "resolved Path for relative symbolic link");
        assertTrue(linkA.linkedResource is File,
            "resolved Resource for relative symbolic link");
    }
}
