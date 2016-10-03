import ceylon.file {
    Nil,
    temporaryDirectory,
    Directory,
    File,
    parsePath,
    Link
}
import ceylon.test {
    assertTrue,
    test,
    assertEquals,
    assertThatException
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

shared test void circularLinks() {
    // Resolve circularLinks as Links, not Nil
    // tmp/linkA -> linkB
    // tmp/linkB -> linkC
    // tmp/linkC -> linkA
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        value linkAPath = tmpDir.path.childPath("linkA");
        assert (is Nil nilLinkA = linkAPath.resource);
        nilLinkA.createSymbolicLink(parsePath("linkB"));

        value linkBPath = tmpDir.path.childPath("linkB");
        assert (is Nil nilLinkB = linkBPath.resource);
        nilLinkB.createSymbolicLink(parsePath("linkC"));

        value linkCPath = tmpDir.path.childPath("linkC");
        assert (is Nil nilLinkC = linkCPath.resource);
        nilLinkC.createSymbolicLink(parsePath("linkA"));

        assertTrue(linkAPath.resource is Link,
            "symlink resource that is not ultimately a File|Dir is a Link");

        assertThatException(() => linkAPath.resource.linkedResource);

        assertEquals(linkAPath.resource.path, linkAPath,
            "a resource's path is its path");
    }
}

shared test void linksToNothing() {
    // Ultimately resolve links to Nil
    // tmp/linkA -> linkB
    // tmp/linkB -> nilC
    // (tmp/nilC doesn't exist)
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        value linkAPath = tmpDir.path.childPath("linkA");
        assert (is Nil nilLinkA = linkAPath.resource);
        nilLinkA.createSymbolicLink(parsePath("linkB"));

        value linkBPath = tmpDir.path.childPath("linkB");
        assert (is Nil nilLinkB = linkBPath.resource);
        nilLinkB.createSymbolicLink(parsePath("nilC"));

        value nilCPath = tmpDir.path.childPath("nilC");

        assertTrue(linkAPath.resource is Link,
            "symlink resource that is not ultimately a File|Dir is a Link");

        assertTrue(linkAPath.resource.linkedResource is Nil,
            "a non-circular symlink that does not ultimately resolves to a file|dir
             should have a Nil linkedResource for the ultimate path.");

        assertEquals(linkAPath.resource.linkedResource.path, nilCPath,
            "a non-circular symlink that does not ultimately resolves to a file|dir
             should have a Nil linkedResource for the ultimate path.");
    }
}
