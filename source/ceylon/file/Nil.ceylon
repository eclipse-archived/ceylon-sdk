"Represents the absence of any existing file or directory 
 at a certain path in a hierarchical file system."
shared sealed interface Nil 
        satisfies Resource {
    
    "Create a new file at the location that this object
     represents."
    shared formal File createFile(Boolean includingParentDirectories = false);
    
    "Create a new directory at the location that this 
     object represents."
    shared formal Directory createDirectory(Boolean includingParentDirectories = false);
    
    "Create a new symbolic link at the location that this
     object represents."
    throws (`class Exception`,
        "If symbolic links are not supported on the [[System]]
         associated with this [[Resource]].")
    shared formal Link createSymbolicLink(
            "The target of the symbolic link."
            Path linkedPath,
            Boolean includingParentDirectories = false);
}
