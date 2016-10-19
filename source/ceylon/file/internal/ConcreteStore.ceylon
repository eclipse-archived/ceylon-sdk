import ceylon.file {
    Store
}

import java.nio.file {
    JFileStore=FileStore,
    FileSystems {
        defaultFileSystem=default
    }
}

shared Store[] stores
        => [ for (store in defaultFileSystem.fileStores)
             ConcreteStore(store) ];

class ConcreteStore(JFileStore jstore) 
        satisfies Store {
    
    totalSpace => jstore.totalSpace;
    
    availableSpace => jstore.unallocatedSpace;
    
    usableSpace => jstore.usableSpace;
    
    name => jstore.name();
    
    writable => !jstore.readOnly;
    
}