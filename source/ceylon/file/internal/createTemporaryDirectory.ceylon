import ceylon.file {
    Directory
}

import java.nio.file {
    JFiles=Files
}

shared Directory createTemporaryDirectory(
        String? prefix = null,
        Directory? parentDirectory = null) {

    value jpath
        =   if (exists parentDirectory)
            then JFiles.createTempDirectory(
                toJpath(parentDirectory.path), prefix)
            else JFiles.createTempDirectory(prefix);

    return ConcreteDirectory(jpath);
}
