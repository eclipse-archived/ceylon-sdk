doc "Represents a file in a hierarchical filesystem."
shared interface File 
        satisfies Resource {
    
    doc "The directory containing this file."
    shared formal Directory directory;
    
    doc "Move this file to the given location."
    shared formal File move(Nil target);
    
    doc "Move this file to the given location."
    shared formal File moveOverwriting(File|Nil target);
    
    doc "Copy this file to the given location."
    shared formal File copy(Nil target);
    
    doc "Copy this file to the given location."
    shared formal File copyOverwriting(File|Nil target);
    
    doc "Delete this file."
    shared formal Nil delete();
    
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
    
    doc "The timestamp of the last modification of this 
         file."
    shared formal Integer lastModifiedMilliseconds;
    
    doc "The store to which this file belongs."
    shared formal Store store;
    
    doc "A `Reader` for reading lines of text from this
         file."
    shared formal Reader reader(String? encoding/*=null*/);
    
    doc "A `Writer` for writing text to this file, after
         truncating the file to length 0."
    shared formal Writer writer(String? encoding/*=null*/);
    
    doc "A `Writer` for appending text to this file"
    shared formal Writer appender(String? encoding/*=null*/);
    
}