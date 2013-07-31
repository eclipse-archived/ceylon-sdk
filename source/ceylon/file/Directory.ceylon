"Represents a directory in a hierarchical file system."
shared interface Directory 
        satisfies ExistingResource {
    
    "The files and subdirectories that directly belong
     to this directory."
    shared formal {ExistingResource*} children(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");
    
    "The files that directly belong to this directory."
    shared formal {File*} files(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");    
    
    "The subdirectories that directly belong to this 
     directory."
    shared formal {Directory*} childDirectories(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");
    
    "The paths of all files and subdirectories that 
     directly belong to this directory."
    shared formal {Path*} childPaths(
            "A filter to apply to the file names,
             expressed as a glob pattern."
            String filter="*");
    
    "Obtain a resource belonging to this directory."
    shared formal Resource childResource(Path|String subpath);
    
    "Move this directory to the given location."
    shared formal Directory move(Nil target);
        
}

"The `Directory`s representing the root directories of
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