import ceylon.file {
    File,
    Directory,
    Path
}
import java.nio.file {
    JFiles=Files,
    JPath=Path,
    FileSystems {
        defaultFileSystem=default
    }
}

shared File createTemporaryFile(
        String? prefix = null,
        String? suffix = null,
        Directory? parentDirectory = null,
        Boolean deleteOnExit = false) {

    value jpath
        =   if (exists parentDirectory)
            then JFiles.createTempFile(
                toJpath(parentDirectory.path), prefix, suffix)
            else JFiles.createTempFile(prefix, suffix);

    if (deleteOnExit) {
        jpath.toFile().deleteOnExit();
    }

    return ConcreteFile(jpath);
}

JPath toJpath(Path path)
    =>  FileSystems.default.getPath(path.string);
