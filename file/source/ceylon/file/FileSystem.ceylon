import ceylon.file.internal { internalCreateFileSystem=createFileSystem }

doc "Represents a special-purpose file system."
shared interface FileSystem {
    
    doc "Obtain a `Path` in this file system given the 
         string representation of a path."
    shared formal Path parsePath(String pathString);
    
    doc "Close this file system."
    shared formal void close();
    
}

shared FileSystem createFileSystem(String uriString, String->String... properties) 
        = internalCreateFileSystem;
