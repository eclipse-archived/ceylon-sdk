doc "Represents a file or directory located at a certain
     path, or the absence of a file or directory at the
     path."
shared interface Resource 
        of File|Directory|Nil { //TODO: links!
    
    doc "The path of the file or directory."
	shared formal Path path;
    
}

doc "Represents a file in a hierarchical filesystem."
shared interface File 
        satisfies Resource {
    
    doc "Move this file. If the given resource is a
         directory, move this file into the directory.
         If the given resource is a file, overwrite
         the file. If the given resource is nil, move
         this file to the location it represents."
    see (moveInto, moveTo)
    shared formal File move(Directory|File|Nil target);
    
    doc "Move this file into the given directory."
    shared formal File moveInto(Directory target);
    
    doc "Move this file to the given location."
    shared formal File moveTo(File|Nil target);
    
    doc "Copy this file. If the given resource is a
         directory, copy this file into the directory.
         If the given resource is a file, overwrite
         the file. If the given resource is nil, copy
         this file to the location it represents."
    see (copyInto, copyTo)
    shared formal File copy(Directory|File|Nil target);
        
    doc "Copy this file into the given directory."
    shared formal File copyInto(Directory target);
    
    doc "Copy this file to the given location."
    shared formal File copyTo(File|Nil target);
    
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

doc "Represents a directory in a hierarchical filesystem."
shared interface Directory 
        satisfies Resource {
    
    doc "The files and subdirectories that directly belong
         to this directory."
    shared formal Empty|Sequence<File|Directory> children;
    
    doc "The files that directly belong to this directory."
    shared formal File[] files;
    
    doc "The subdirectories that directly belong to this 
         directory."
    shared formal Directory[] childDirectories;
    
    doc "The paths of all files and subdirectories that 
         directly belong to this directory."
    shared formal Path[] childPaths;
    
    doc "Move this directory. If the given resource is a
         directory, move this directory into the directory.
         If the given resource is nil, move this directory 
         to the location it represents."
    see (moveInto, moveTo)
    shared formal Directory move(Directory|Nil target);
    
    doc "Move this directory into the given directory."
    shared formal Directory moveInto(Directory target);
    
    doc "Move this directory to the given location."
    shared formal Directory moveTo(Nil target);
    
    doc "Delete this directory."
    shared formal Nil delete();
    
}

doc "Represents the absence of any existing file or directory 
     at a certain path in a hierarchical filesystem."
shared interface Nil 
        satisfies Resource {
    
    doc "Create a new file at the location that this object
         represents."
    shared formal File createFile();
    
    doc "Create a new directory at the location that this 
         object represents."
    shared formal Directory createDirectory();
    
}

doc "The `Directory`s representing the root directories of
     the filesystem."
shared Directory[] rootDirectories {
    value sb = SequenceBuilder<Directory>();
    for (p in rootPaths) {
        if (is Directory r=p.resource) {
            sb.append(r);
        }
    }
    return sb.sequence;
}