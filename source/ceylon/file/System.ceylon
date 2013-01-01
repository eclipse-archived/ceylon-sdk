import ceylon.file { defaultParsePath=parsePath, defaultRootPaths=rootPaths, 
                     defaultStores=stores }
import ceylon.file.internal { internalCreateSystem=createSystem }

doc "Represents a special-purpose file system."
shared interface System {
    
    doc "Obtain a `Path` in this file system given the 
         string representation of a path."
    shared formal Path parsePath(String pathString);
    
    doc "The `Path`s representing the root directories of
         the file system."
    shared formal Path[] rootPaths;
    
    doc "The `Store`s belonging to this file system."
    shared formal Store[] stores;
    
    doc "Determine if this system can be written to."
    shared formal Boolean writeable;
    
    doc "Close this `System`."
    shared formal void close();

    doc "Determine if this `System` is open."
    shared formal Boolean open;
    
}

doc "Create a `System` given a URI and a sequence of 
     named values."
shared System createSystem(
        doc "The URI, as a string."
        String uriString,
        doc "A sequence of file system-specific named 
             values." 
        String->String... properties) 
        => internalCreateSystem(uriString, properties...);

doc "Create a `System` for accessing entries in a zip 
     file."
shared System createZipFileSystem(
        doc "The zip file. If `Nil`, a new zip file
             will be automatically created." 
        File|Nil file, 
        doc "The character encoding for entry names." 
        String encoding="UTF-8") {
    return createSystem("jar:" + file.path.uriString, 
            {"create"->(file is Nil).string, 
            "encoding"->encoding}...);
} 

doc "A `System` representing the default file system."
shared object defaultSystem 
        satisfies System {
    shared actual Path parsePath(String pathString) {
        return defaultParsePath(pathString);
    }
    shared actual Path[] rootPaths {
        return defaultRootPaths;
    }
    shared actual Store[] stores {
        return defaultStores;
    }
    shared actual Boolean open {
        return true;
    }
    shared actual Boolean writeable {
        return true;
    }
    shared actual void close() {
        throw;
    }
}