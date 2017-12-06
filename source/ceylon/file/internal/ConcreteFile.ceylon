/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
    StandardCopyOption,
    StandardOpenOption
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
                    *(copyAttributes then [StandardCopyOption.copyAttributes] else [])) );
    
    copyOverwriting(File|Nil target, Boolean copyAttributes) =>
            ConcreteFile( copyPath(jpath, asJPath(target.path, jpath),
                    *(copyAttributes then [StandardCopyOption.replaceExisting,
                                           StandardCopyOption.copyAttributes]
                                     else [StandardCopyOption.replaceExisting])) );
    
    move(Nil target) =>
            ConcreteFile(movePath(jpath, asJPath(target.path, jpath)));
    
    moveOverwriting(File|Nil target) =>
            ConcreteFile(movePath(jpath, asJPath(target.path, jpath),
                StandardCopyOption.replaceExisting) );
    
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

    deleteOnExit() => jpath.toFile().deleteOnExit();

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
        
        readBytes(Integer max)
                => let (byteArray = ByteArray(max),
                        size = stream.read(byteArray))
                if (size<=0)
                    then []
                else if (size==max)
                    then byteArray.byteArray.sequence()
                else byteArray.iterable.take(size).sequence();

    }
    
    shared actual class Overwriter(String? encoding, 
            Integer bufferSize) 
            extends super.Overwriter(encoding, bufferSize) {
        value charset = parseCharset(encoding);
        
        value stream = 
                newOutputStream(jpath,
                    StandardOpenOption.write,
                    StandardOpenOption.truncateExisting);
        
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
                byteArray[i++] = b;
            }
            stream.write(byteArray);
        }
                
    }
    
    shared actual class Appender(String? encoding, 
            Integer bufferSize) 
            extends super.Appender(encoding, bufferSize) {
        value charset = parseCharset(encoding);
        
        value stream = 
                newOutputStream(jpath,
                    StandardOpenOption.write,
                    StandardOpenOption.append);
        
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
                byteArray[i++] = b;
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
