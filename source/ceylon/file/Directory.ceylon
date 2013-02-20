doc "Represents a directory in a hierarchical file system."
shared interface Directory 
        satisfies ExistingResource {
    
    doc "The files and subdirectories that directly belong
         to this directory."
    shared formal {ExistingResource*} children(
            doc "A filter to apply to the file names,
                 expressed as a glob pattern."
            String filter="*");
    
    doc "The files that directly belong to this directory."
    shared formal {File*} files(
            doc "A filter to apply to the file names,
                 expressed as a glob pattern."
            String filter="*");    
    
    doc "The subdirectories that directly belong to this 
         directory."
    shared formal {Directory*} childDirectories(
            doc "A filter to apply to the file names,
                 expressed as a glob pattern."
            String filter="*");
    
    doc "The paths of all files and subdirectories that 
         directly belong to this directory."
    shared formal {Path*} childPaths(
            doc "A filter to apply to the file names,
                 expressed as a glob pattern."
            String filter="*");
    
    doc "Obtain a resource belonging to this directory."
    shared formal Resource childResource(Path|String subpath);
    
    doc "Move this directory to the given location."
    shared formal Directory move(Nil target);
        
}

doc "The `Directory`s representing the root directories of
     the default file system."
see (defaultSystem)
shared Directory[] rootDirectories {
    value sb = SequenceBuilder<Directory>();
    for (p in rootPaths) {
        if (is Directory r=p.resource) {
            sb.append(r);
        }
    }
    return sb.sequence;
}