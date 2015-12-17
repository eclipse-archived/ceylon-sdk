import ceylon.file {
    Directory
}

import java.nio.file {
    JFiles=Files
}

shared Directory createTemporaryDirectory(
        String? prefix,
        Directory parentDirectory)
    =>  ConcreteDirectory(JFiles.createTempDirectory(
            toJpath(parentDirectory.path), prefix));
