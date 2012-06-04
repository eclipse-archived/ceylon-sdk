import ceylon.file { ... }
import java.nio.file { JFileStore=FileStore, 
                       FileSystems { defaultFileSystem=default } }

shared Store[] stores {
    value sb = SequenceBuilder<Store>();
    value iter = defaultFileSystem.fileStores.iterator();
    while (iter.hasNext()) {
        sb.append(ConcreteStore(iter.next()));
    }
    return sb.sequence;
}

class ConcreteStore(JFileStore jstore) 
        satisfies Store {
    shared actual Integer totalSpace {
        return jstore.totalSpace;
    }
    shared actual Integer availableSpace {
        return jstore.unallocatedSpace;
    }
    shared actual Integer usableSpace {
        return jstore.usableSpace;
    }
    shared actual String name {
        return jstore.name();
    }
    shared actual Boolean writable {
        return !jstore.readOnly;
    }
}