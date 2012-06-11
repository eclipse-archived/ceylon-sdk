doc "Represents the absence of any existing file or directory 
     at a certain path in a hierarchical file system."
shared interface Nil 
        satisfies Resource {
    
    doc "Create a new file at the location that this object
         represents."
    shared formal File createFile();
    
    doc "Create a new directory at the location that this 
         object represents."
    shared formal Directory createDirectory();
    
}