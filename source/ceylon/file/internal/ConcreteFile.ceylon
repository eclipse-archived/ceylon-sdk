import ceylon.file {
    ...
}

import java.io {
    BufferedReader,
    InputStreamReader,
    BufferedWriter,
    OutputStreamWriter
}
import java.lang {
    ByteArray
}
import java.nio.file {
    JPath=Path,
    Paths {
        newPath=get
    },
    Files {
        isReadable,
        isWritable,
        isExecutable,
        isSameFile,
        getFileStore,
        getSize=size,
        isHidden,
        getLastModifiedTime,
        setLastModifiedTime,
        getAttribute,
        setAttribute,
        probeContentType,
        copyPath=copy,
        movePath=move,
        newLink=createLink,
        deletePath=delete,
        getOwner,
        setOwner,
        newSymbolicLink=createSymbolicLink,
        newInputStream,
        newOutputStream
    },
    StandardCopyOption {
        REPLACE_EXISTING,
        COPY_ATTRIBUTES
    },
    StandardOpenOption {
        WRITE,
        APPEND,
        TRUNCATE_EXISTING
    }
}
import java.nio.file.attribute {
    FileTime {
        fromMillis
    }
}


class ConcreteFile(JPath jpath)
        satisfies File {
    
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    copy(Nil target, Boolean copyAttributes) =>
            ConcreteFile( copyPath(jpath, asJPath(target.path, jpath),
                    *(copyAttributes then [\iCOPY_ATTRIBUTES] else [])) );
    
    copyOverwriting(File|Nil target, Boolean copyAttributes) =>
            ConcreteFile( copyPath(jpath, asJPath(target.path, jpath),
                    *(copyAttributes then [\iREPLACE_EXISTING, \iCOPY_ATTRIBUTES ]
                                     else [\iREPLACE_EXISTING])) );
    
    move(Nil target) =>
            ConcreteFile( movePath(jpath, asJPath(target.path, jpath)) );
    
    moveOverwriting(File|Nil target) =>
            ConcreteFile( movePath(jpath, asJPath(target.path, jpath),
                    \iREPLACE_EXISTING) );            
    
    createLink(Nil target) =>
            ConcreteFile(newLink(asJPath(target.path, jpath), jpath));
    
    createSymbolicLink(Nil target) =>
            ConcreteLink(newSymbolicLink(asJPath(target.path, jpath), jpath));
    
    readable => isReadable(jpath);
    
    writable => isWritable(jpath);
    
    executable => isExecutable(jpath);
    
    readAttribute(Attribute attribute) 
            => getAttribute(jpath, attributeName(attribute));
    
    writeAttribute(Attribute attribute, Object attributeValue)
            => setAttribute(jpath, attributeName(attribute), 
                                   attributeValue);
    
    shared actual Integer lastModifiedMilliseconds {
        return getLastModifiedTime(jpath).toMillis();
    }
    assign lastModifiedMilliseconds {
        value fileTime = fromMillis(lastModifiedMilliseconds);
        setLastModifiedTime(jpath, fileTime);
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
    
    shared actual String owner => getOwner(jpath).name;
    
    assign owner => setOwner(jpath, jprincipal(jpath,owner));
    
    shared actual class Reader(String? encoding,
            Integer bufferSize) 
            extends super.Reader(encoding, bufferSize) {
        value charset = parseCharset(encoding);
        
        value stream = newInputStream(jpath); 
        
        value reader = 
                BufferedReader(
                    InputStreamReader(stream, 
                        charset.newDecoder()), 
                    bufferSize);
        
        close() => reader.close();
        
        readLine() => reader.readLine();
        
        shared actual Byte[] readBytes(Integer max) {
            value byteArray = ByteArray(max);
            value size = stream.read(byteArray);
            return 
                if (size==max) 
                then (sequence(byteArray.byteArray) else []) 
                else [ for (b in byteArray.iterable) b ];
        }
        
    }
    
    shared actual class Overwriter(String? encoding, 
            Integer bufferSize) 
            extends super.Overwriter(encoding, bufferSize) {
        value charset = parseCharset(encoding);
        
        value stream = 
                newOutputStream(jpath, \iWRITE, 
                    \iTRUNCATE_EXISTING);
        
        value writer = 
                BufferedWriter(
                    OutputStreamWriter(stream, 
                        charset.newEncoder()),
                    bufferSize);
        
        close() => writer.close();
        
        flush() => writer.flush();
        
        write(String string) => writer.write(string);
        
        shared actual void writeLine(String line) {
            writer.write(line); 
            writer.newLine();
        }
        
        shared actual void writeBytes({Byte*} bytes) {
            value byteArray = ByteArray(bytes.size);
            variable value i=0;
            for (b in bytes) {
                byteArray.set(i++, b);
            }
            stream.write(byteArray);
        }
                
    }
    
    shared actual class Appender(String? encoding, 
            Integer bufferSize) 
            extends super.Appender(encoding, bufferSize) {
        value charset = parseCharset(encoding);
        
        value stream = 
                newOutputStream(jpath, \iWRITE, \iAPPEND);
        
        value writer = 
                BufferedWriter(
                    OutputStreamWriter(stream, 
                        charset.newEncoder()),
                    bufferSize);
        
        close() => writer.close();
        
        flush() => writer.flush();
        
        write(String string) => writer.write(string);
        
        shared actual void writeLine(String line) {
            writer.write(line); 
            writer.newLine();
        }
        
        shared actual void writeBytes({Byte*} bytes) {
            value byteArray = ByteArray(bytes.size);
            variable value i=0;
            for (b in bytes) {
                byteArray.set(i++, b);
            }
            stream.write(byteArray);
        }
        
    }

}

shared Boolean sameFile(File x, File y) =>
        let (xPath = x.path, yPath = y.path)
        if (is ConcretePath xPath)
            then let (jpath = xPath.jpath) 
                isSameFile(jpath, asJPath(yPath, jpath))
        else if (is ConcretePath yPath) 
            then let (jpath = yPath.jpath) 
                isSameFile(asJPath(xPath, jpath), jpath)
        else isSameFile(newPath(xPath.string), 
                        newPath(yPath.string));
