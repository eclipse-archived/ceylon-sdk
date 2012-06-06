import ceylon.file { File, Nil, Directory, Store, Reader, Writer }

import java.nio.file { JPath=Path, Files { isReadable, isWritable, isExecutable, 
                                           getFileStore, getSize=size, getLastModifiedTime,
                                           copyPath=copy, movePath=move,
                                           deletePath=delete },
                       StandardCopyOption { REPLACE_EXISTING } }
import java.nio.charset { Charset { defaultCharset, forName } }

Charset parseCharset(String? encoding) {
    if (exists encoding) {
        return forName(encoding);
    }
    else {
        return defaultCharset();
    }
}

class ConcreteFile(JPath jpath)
        extends ConcreteResource(jpath) 
        satisfies File {
    shared actual File copy(Nil target) {
            return ConcreteFile( copyPath(jpath, asJPath(target.path)) );
    }
    shared actual File copyOverwriting(File|Nil target) {
            return ConcreteFile( copyPath(jpath, asJPath(target.path), 
                    \iREPLACE_EXISTING) );            
    }
    shared actual File move(Nil target) {
            return ConcreteFile( movePath(jpath, asJPath(target.path)) );
    }
    shared actual File moveOverwriting(File|Nil target) {
            return ConcreteFile( movePath(jpath, asJPath(target.path), 
                    \iREPLACE_EXISTING) );            
    }
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    shared actual Boolean readable {
        return isReadable(jpath);
    }
    shared actual Boolean writable {
        return isWritable(jpath);
    }
    shared actual Boolean executable {
        return isExecutable(jpath);
    }
    shared actual Integer lastModifiedMilliseconds {
        return getLastModifiedTime(jpath).toMillis();
    }
    shared actual String name {
        return jpath.fileName.string;
    }
    shared actual Integer size {
        return getSize(jpath);
    }
    shared actual Directory directory {
        return ConcreteDirectory(jpath.parent);
    }
    shared actual Store store {
        return ConcreteStore(getFileStore(jpath));
    }
    shared actual Reader reader(String? encoding) {
        return ConcreteReader(jpath, parseCharset(encoding));
    }
    shared actual Writer writer(String? encoding) {
        return ConcreteWriter(jpath, parseCharset(encoding));
    }
    shared actual Writer appender(String? encoding) {
        return ConcreteAppendingWriter(jpath, parseCharset(encoding));
    }
}