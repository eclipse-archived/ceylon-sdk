shared interface Resource 
        of File|Directory|Nil {
	shared formal Path path;
}

shared interface File 
        satisfies Resource {
    shared formal File move(Directory dir);
    shared formal File copy(Directory nil);
    shared formal File rename(Nil nil);
    shared formal File overwrite(File file);
    shared formal Nil delete();
    shared formal Boolean writable; 
    shared formal Boolean readable; 
    shared formal Boolean executable;
    shared formal String name; 
    shared formal Integer lastModifiedMilliseconds;
    shared formal Store store;
}

shared interface Directory 
        satisfies Resource {
    shared formal Resource[] children;
    shared formal Path[] childPaths;
    shared formal File move(Directory dir);
    shared formal File rename(Nil nil);
    shared formal Nil delete();
    shared formal File createFile(String|Path name);
    shared formal Directory createDirectory(String|Path name);
}

shared interface Nil 
        satisfies Resource {
    shared formal File createFile();
    shared formal Directory createDirectory();
}

shared Directory[] rootDirectories {
    value sb = SequenceBuilder<Directory>();
    for (p in rootPaths) {
        if (is Directory r=p.resource) {
            sb.append(r);
        }
    }
    return sb.sequence;
}