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
        String? prefix,
        String? suffix,
        Directory parentDirectory)
    =>  ConcreteFile(JFiles.createTempFile(
            toJpath(parentDirectory.path), prefix, suffix));

JPath toJpath(Path path)
    =>  FileSystems.default.getPath(path.string);
