import ceylon.file {
    Store
}

import ceylon.collection {
    ArrayList
}

import java.nio.file {
    JFileStore=FileStore,
    FileSystems {
        defaultFileSystem=default
    }
}

shared Store[] stores {
    value sb = ArrayList<Store>();
    value iter = defaultFileSystem.fileStores.iterator();
    while (iter.hasNext()) {
        sb.add(ConcreteStore(iter.next()));
    }
    return sb.sequence;
}

class ConcreteStore(JFileStore jstore) 
        satisfies Store {
    
    totalSpace => jstore.totalSpace;
    
    availableSpace => jstore.unallocatedSpace;
    
    usableSpace => jstore.usableSpace;
    
    name => jstore.name();
    
    writable => !jstore.readOnly;
    
}