import ceylon.file {
    ...
}

import ceylon.collection {
    ArrayList
}

import java.lang {
    JString=String
}
import java.net {
    URI {
        newURI=create
    }
}
import java.nio.file {
    FileSystem,
    FileSystems {
        newFileSystem
    }
}
import java.util {
    HashMap
}

class ConcreteSystem(FileSystem fs) 
        satisfies System {
    
    close() => fs.close();
    
    open => fs.open;
    
    writeable => !fs.readOnly;
    
    parsePath(String pathString) =>
            ConcretePath(fs.getPath(pathString));
     
    shared actual Path[] rootPaths {
        value sb = ArrayList<Path>();
        value iter = fs.rootDirectories.iterator();
        while (iter.hasNext()) {
            sb.add(ConcretePath(iter.next()));
        }
        return sb.sequence();
    }
    
    shared actual Store[] stores {
        value sb = ArrayList<Store>();
        value iter = fs.fileStores.iterator();
        while (iter.hasNext()) {
            sb.add(ConcreteStore(iter.next()));
        }
        return sb.sequence();
    }
    
}

shared System createSystem(String uriString, <String->String>* properties) {
    value map = HashMap<JString,Object>();
    for (entry in properties) {
        map.put(JString(entry.key), JString(entry.item));
    }
    value fs = newFileSystem(newURI(uriString), map);
    return ConcreteSystem(fs);
}
