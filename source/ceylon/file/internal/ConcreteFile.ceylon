import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { isReadable, isWritable, isExecutable, isSameFile,
                               getFileStore, getSize=size, isHidden,
                               getLastModifiedTime, setLastModifiedTime,
                               probeContentType, copyPath=copy, movePath=move,
                               newLink=createLink, 
                               deletePath=delete,
                               getOwner, setOwner,
                               newSymbolicLink=createSymbolicLink,
                               newBufferedReader, newBufferedWriter },
                       StandardCopyOption { REPLACE_EXISTING },
                       StandardOpenOption { WRITE, APPEND, TRUNCATE_EXISTING } }
import java.nio.file.attribute { FileTime { fromMillis } }
import java.nio.charset { Charset }


class ConcreteFile(JPath jpath)
        satisfies File {
    
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    copy(Nil target) =>
            ConcreteFile( copyPath(jpath, asJPath(target.path)) );
    
    copyOverwriting(File|Nil target) =>
            ConcreteFile( copyPath(jpath, asJPath(target.path), 
                    \iREPLACE_EXISTING) );            
    
    move(Nil target) =>
            ConcreteFile( movePath(jpath, asJPath(target.path)) );
    
    moveOverwriting(File|Nil target) =>
            ConcreteFile( movePath(jpath, asJPath(target.path), 
                    \iREPLACE_EXISTING) );            
    
    createLink(Nil target) =>
            ConcreteFile(newLink(asJPath(target.path), jpath));
    
    createSymbolicLink(Nil target) =>
            ConcreteLink(newSymbolicLink(asJPath(target.path), jpath));
    
    readable => isReadable(jpath);
    
    writable => isWritable(jpath);
    
    executable => isExecutable(jpath);
    
    shared actual Integer lastModifiedMilliseconds {
        return getLastModifiedTime(jpath).toMillis();
    }
    assign lastModifiedMilliseconds {
        setLastModifiedTime(jpath, fromMillis(lastModifiedMilliseconds));
    }
    
    name => jpath.fileName.string;
    
    size => getSize(jpath);
    
    contentType => probeContentType(jpath);
    
    hidden => isHidden(jpath);
    
    directory => ConcreteDirectory(jpath.parent);
    
    store => ConcreteStore(getFileStore(jpath));
    
    //reader(String? encoding) =>
    //        ConcreteReader(jpath, parseCharset(encoding));
    //
    //writer(String? encoding) =>
    //        ConcreteWriter(jpath, parseCharset(encoding));
    //
    //appender(String? encoding) =>
    //        ConcreteAppendingWriter(jpath, parseCharset(encoding));
    
    path => ConcretePath(jpath);
    
    linkedResource => this;
    
    string => jpath.string;
    
    shared actual String owner {
        return getOwner(jpath).name;
    }
    assign owner {
        setOwner(jpath, jprincipal(jpath,owner));
    }
    
    shared actual class Reader(String? encoding) 
            extends super.Reader(encoding) {
        value charset = parseCharset(encoding);
        
        value r = newBufferedReader(jpath, charset);
        
        readLine() => r.readLine();
        
        destroy() => r.close();
        
    }
    
    shared actual class Overwriter(String? encoding) 
            extends super.Overwriter(encoding) {
        value charset = parseCharset(encoding);
        
        value w = newBufferedWriter(jpath, charset, 
                \iWRITE, \iTRUNCATE_EXISTING);
        
        destroy() => w.close();
        
        write(String string) => w.write(string);
        
        shared actual void writeLine(String line) {
            w.write(line); w.newLine();
        }
        
        flush() => w.flush();
        
    }
    
    shared actual class Appender(String? encoding) 
            extends super.Appender(encoding) {
        value charset = parseCharset(encoding);
        
        value w = newBufferedWriter(jpath, charset, 
                \iWRITE, \iAPPEND);
        
        destroy() => w.close();
        
        write(String string) => w.write(string);
        
        shared actual void writeLine(String line) {
            w.write(line); w.newLine();
        }
        
        flush() => w.flush();
        
    }

}

shared Boolean sameFile(File x, File y) =>
        isSameFile(asJPath(x.path), asJPath(y.path));
