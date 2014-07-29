"Represents a symbolic link."
shared sealed interface Link 
        satisfies ExistingResource {
    
    "The linked path."
    shared formal Path linkedPath;
    
}