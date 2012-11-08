doc "Represents a symbolic link."
shared interface Link 
        satisfies ExistingResource {
    
    doc "The linked path."
    shared formal Path linkedPath;
    
}