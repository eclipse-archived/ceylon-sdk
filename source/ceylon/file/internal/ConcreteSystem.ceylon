import ceylon.file {
    ...
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
    
    parsePath(String pathString)
            => ConcretePath(fs.getPath(pathString));
     
    rootPaths => [for (path in fs.rootDirectories) ConcretePath(path)];
    
    stores => [for (store in fs.fileStores) ConcreteStore(store)];
    
}

shared System createSystem(String uriString, <String->String>* properties) {
    value map = HashMap<JString,Object>();
    for (entry in properties) {
        map[JString(entry.key)] = JString(entry.item);
    }
    return ConcreteSystem(newFileSystem(newURI(uriString), map));
}
