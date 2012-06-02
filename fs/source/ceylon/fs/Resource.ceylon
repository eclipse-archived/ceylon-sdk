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
}

shared interface Directory 
        satisfies Resource {
    shared formal Resource[] children;
    shared formal Path[] childPaths;
}

shared interface Nil 
        satisfies Resource {
    shared formal File createFile();
    shared formal Directory createDirectory();
}
