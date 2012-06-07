doc "Represents a symbolic link."
shared interface Link 
        satisfies ExistingResource {
    
    doc "The linked path."
    shared formal Path linkedPath;
    
    doc "Delete this link."
    shared formal Nil delete();
    
}