import ceylon.file {
    Directory
}

shared Directory temporaryDirectory() {
    value tempDirString = process.propertyValue("java.io.tmpdir");
    if (!exists tempDirString) {
        throw AssertionError(
            "Cannot determine system temporary directory path; \
             system property 'java.io.tmpdir' is not set.");
    }
    value directory = parsePath(tempDirString).resource.linkedResource;
    if (!is Directory directory) {
        throw AssertionError(
            "Configured temporary directory path '``tempDirString``'
             is not a directory; please check system property
             'java.io.tmpdir'.");
    }
    return directory;
}
