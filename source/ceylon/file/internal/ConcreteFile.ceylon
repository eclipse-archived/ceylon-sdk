import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { isReadable, isWritable, isExecutable, isSameFile,
                               getFileStore, getSize=size, isHidden,
                               getLastModifiedTime, setLastModifiedTime,
                               probeContentType, copyPath=copy, movePath=move,
                               newLink=createLink, 
                               deletePath=delete,
                               getOwner, setOwner,
                               newSymbolicLink=createSymbolicLink },
                       StandardCopyOption { REPLACE_EXISTING } }
import java.nio.charset { Charset { defaultCharset, forName } }
import java.nio.file.attribute { FileTime { fromMillis }, 
                                 UserPrincipalNotFoundException }

Charset parseCharset(String? encoding) {
    if (exists encoding) {
        return forName(encoding);
    }
    else {
        return defaultCharset();
    }
}

class ConcreteFile(JPath jpath)
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
    shared actual File createLink(Nil target) {
        return ConcreteFile(newLink(asJPath(target.path), jpath));
    }
    shared actual Link createSymbolicLink(Nil target) {
        return ConcreteLink(newSymbolicLink(asJPath(target.path), jpath));
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
    assign lastModifiedMilliseconds {
        setLastModifiedTime(jpath, fromMillis(lastModifiedMilliseconds));
    }
    shared actual String name {
        return jpath.fileName.string;
    }
    shared actual Integer size {
        return getSize(jpath);
    }
    shared actual String? contentType {
        return probeContentType(jpath);
    }
    shared actual Boolean hidden {
        return isHidden(jpath);
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
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    function jprincipal(String name) {
        value upls = jpath.fileSystem.userPrincipalLookupService;
        try {
            return upls.lookupPrincipalByName(name);
        }
        catch (UserPrincipalNotFoundException e) {
            throw NoSuchPrincipalException(name, e);
        }
    }
    
    shared actual String owner {
        return getOwner(jpath).name;
    }
    assign owner {
        setOwner(jpath, jprincipal(owner));
    }
    
    shared actual Path path { 
        return ConcretePath(jpath); 
    }
    shared actual File|Directory|Nil linkedResource {
        return this;
    }
    shared actual String string {
        return jpath.string;
    }
}

shared Boolean sameFile(File x, File y) {
    return isSameFile(asJPath(x.path), asJPath(y.path));
}
