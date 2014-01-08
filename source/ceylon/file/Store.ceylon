import ceylon.file.internal {
    storesInternal=stores
}

"Represents a file system store."
shared interface Store {
    
    "The total number of bytes that can be
     held by this store."
    shared formal Integer totalSpace;
    
    "The total number of bytes that are 
     available in this store."
    see(`value usableSpace`)
    shared formal Integer availableSpace;
    
    "The total number of bytes that may be
     written to this store by this process,
     taking into account permissions, etc."
    see(`value availableSpace`)
    shared formal Integer usableSpace;
    
    "Determine if this store can be written to."
    shared formal Boolean writable;
    
    "The name of this store."
    shared formal String name;
}

"The `Store`s representing the stores of the
 default file system."
see(`value defaultSystem`)
shared Store[] stores = storesInternal;