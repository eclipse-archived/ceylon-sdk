import ceylon.file {
    Directory
}

import java.nio.file {
    JFiles=Files
}

shared Directory createTemporaryDirectory(
        String? prefix = null,
        Directory? parentDirectory = null,
        Boolean deleteOnExit = false) {

    value jpath
        =   if (exists parentDirectory)
            then JFiles.createTempDirectory(
                toJpath(parentDirectory.path), prefix)
            else JFiles.createTempDirectory(prefix);

    if (deleteOnExit) {
        jpath.toFile().deleteOnExit();
    }

    return ConcreteDirectory(jpath);
}
