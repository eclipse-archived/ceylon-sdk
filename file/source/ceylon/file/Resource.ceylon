doc "Represents a file or directory located at a certain
     path, or the absence of a file or directory at the
     path."
shared interface Resource 
        of File|Directory|Nil { //TODO: links!
    
    doc "The path of the file or directory."
	shared formal Path path;
    
}
