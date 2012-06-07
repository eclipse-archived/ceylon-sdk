import ceylon.file { System, Path, Store }

import java.lang { JString=String }
import java.net { URI { newURI=create } }
import java.nio.file { FileSystem, FileSystems { newFileSystem } }
import java.util { HashMap }

class ConcreteSystem(FileSystem fs) 
        satisfies System {
    shared actual void close() {
        fs.close();
    }
    shared actual Boolean open {
        return fs.open;
    }
    shared actual Boolean writeable {
        return !fs.readOnly;
    }
    shared actual Path parsePath(String pathString) {
        return ConcretePath(fs.getPath(pathString));
    }   
    shared actual Path[] rootPaths {
        value sb = SequenceBuilder<Path>();
        value iter = fs.rootDirectories.iterator();
        while (iter.hasNext()) {
            sb.append(ConcretePath(iter.next()));
        }
        return sb.sequence;
    }
    shared actual Store[] stores {
        value sb = SequenceBuilder<Store>();
        value iter = fs.fileStores.iterator();
        while (iter.hasNext()) {
            sb.append(ConcreteStore(iter.next()));
        }
        return sb.sequence;
    }
}

shared System createSystem(String uriString, String->String... properties) {
    value map = HashMap<JString,Object>();
    for (entry in properties) {
        map.put(JString(entry.key), JString(entry.item));
    }
    value fs = newFileSystem(newURI(uriString), map);
    return ConcreteSystem(fs);
}
