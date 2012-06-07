import ceylon.file { defaultParsePath=parsePath }
import ceylon.file.internal { internalCreateSystem=createSystem }

doc "Represents a special-purpose file system."
shared interface System {
    
    doc "Obtain a `Path` in this file system given the 
         string representation of a path."
    shared formal Path parsePath(String pathString);
    
    doc "Close this file system."
    shared formal void close();
    
}

shared System createSystem(String uriString, String->String... properties) 
        = internalCreateSystem;

shared object defaultSystem 
        satisfies System {
    shared actual Path parsePath(String pathString) {
        return defaultParsePath(pathString);
    }
    shared actual void close() {
        throw;
    }
}