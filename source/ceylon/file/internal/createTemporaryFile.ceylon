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
        Directory? parentDirectory = null) {

    value jpath
        =   if (exists parentDirectory)
            then JFiles.createTempFile(
                toJpath(parentDirectory.path), prefix, suffix)
            else JFiles.createTempFile(prefix, suffix);

    return ConcreteFile(jpath);
}

JPath toJpath(Path path)
    =>  FileSystems.default.getPath(path.string);
