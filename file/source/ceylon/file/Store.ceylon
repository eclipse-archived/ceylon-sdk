import ceylon.file.internal { storesInternal=stores }

doc "Represents a file system store."
shared interface Store {
    
    doc "The total number of bytes that can be
         held by this store."
    shared formal Integer totalSpace;
    
    doc "The total number of bytes that are 
         available in this store."
    see (usableSpace)
    shared formal Integer availableSpace;
    
    doc "The total number of bytes that may be
         written to this store by this process,
         taking into account permissions, etc."
    see (availableSpace)
    shared formal Integer usableSpace;
    
    doc "Determine if this store can be written
         to."
    shared formal Boolean writable;
    
    doc "The name of this store."
    shared formal String name;
}

doc "The `Store`s representing the stores of the
     default file system."
see (defaultSystem)
shared Store[] stores = storesInternal;