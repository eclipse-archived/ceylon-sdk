import java.nio.file.attribute {
    BasicFileAttributeView,
    PosixFileAttributeView,
    DosFileAttributeView
}

"""A view-name, attribute-name pair that identifies a file
   system attribute, for example `["dos", "hidden"]`,
   `["posix", "group"]`, `["unix", "uid"]`, or 
   `["basic", "lastAccessTime"]`."""
see (`interface BasicFileAttributeView`)
see (`interface PosixFileAttributeView`)
see (`interface DosFileAttributeView`)
shared alias Attribute => [String,String];