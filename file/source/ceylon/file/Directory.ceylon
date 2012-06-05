doc "Represents a directory in a hierarchical filesystem."
shared interface Directory 
        satisfies Resource {
    
    doc "The files and subdirectories that directly belong
         to this directory."
    shared formal Iterable<File|Directory> children(String filter/*="*"*/);
    
    doc "The files that directly belong to this directory."
    shared formal Iterable<File> files(String filter/*="*"*/);
    
    doc "The subdirectories that directly belong to this 
         directory."
    shared formal Iterable<Directory> childDirectories(String filter/*="*"*/);
    
    doc "The paths of all files and subdirectories that 
         directly belong to this directory."
    shared formal Iterable<Path> childPaths(String filter/*="*"*/);
    
    doc "Obtain a resource belonging to this directory."
    shared formal Resource childResource(Path|String subpath);
    
    doc "Move this directory to the given location."
    shared formal Directory move(Nil target);
    
    doc "Delete this directory."
    shared formal Nil delete();
    
}

doc "The `Directory`s representing the root directories of
     the filesystem."
shared Directory[] rootDirectories {
    value sb = SequenceBuilder<Directory>();
    for (p in rootPaths) {
        if (is Directory r=p.resource()) {
            sb.append(r);
        }
    }
    return sb.sequence;
}