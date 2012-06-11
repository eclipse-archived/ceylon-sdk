import ceylon.file.internal { sameFileInternal=sameFile }

doc "Represents a file in a hierarchical file system."
shared interface File 
        satisfies ExistingResource {
    
    doc "The directory containing this file."
    shared formal Directory directory;
    
    doc "Move this file to the given location."
    shared formal File move(Nil target);
    
    doc "Move this file to the given location,
         overwriting the target if it already exists."
    shared formal File moveOverwriting(File|Nil target);
    
    doc "Copy this file to the given location."
    shared formal File copy(Nil target);
    
    doc "Copy this file to the given location,
         overwriting the target if it already exists."
    shared formal File copyOverwriting(File|Nil target);
    
    doc "Create a hard link to this file."
    shared formal File createLink(Nil target);
    
    doc "Create a symbolic link to this file."
    shared formal Link createSymbolicLink(Nil target);
    
    doc "Determine if this file may be written to."
    shared formal Boolean writable;
    
    doc "Determine if this file may be read from."
    shared formal Boolean readable;
    
    doc "Determine if this file may be executed."
    shared formal Boolean executable;
    
    doc "The name of this file."
    shared formal String name;
    
    doc "The size of this file, in bytes."
    shared formal Integer size;
    
    doc "Determine if this file is considered hidden."
    shared formal Boolean hidden;
    
    doc "Determine the content type of this file, if
         possible."
    shared formal String? contentType;
    
    doc "The timestamp of the last modification of this 
         file."
    shared formal variable Integer lastModifiedMilliseconds;
    
    doc "The store to which this file belongs."
    shared formal Store store;
    
    doc "A `Reader` for reading lines of text from this
         file."
    shared formal Reader reader(
            doc "The character encoding to use, where
                 `null` indicates that the platform 
                 default character encoding should be
                 used."
            String? encoding=null);
    
    doc "A `Writer` for writing text to this file, after
         truncating the file to length 0."
    shared formal Writer writer(
            doc "The character encoding to use, where
                 `null` indicates that the platform 
                 default character encoding should be
                 used."
            String? encoding=null);
    
    doc "A `Writer` for appending text to this file"
    shared formal Writer appender(
            doc "The character encoding to use, where
                 `null` indicates that the platform 
                 default character encoding should be
                 used."
            String? encoding=null);
    
}

shared Boolean sameFile(File x, File y) = sameFileInternal;