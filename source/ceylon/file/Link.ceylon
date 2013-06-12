"Represents a symbolic link."
shared interface Link 
        satisfies ExistingResource {
    
    "The linked path."
    shared formal Path linkedPath;
    
}