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

import java.nio.file {
    JPath=Path,
    Files {
        movePath=move,
        newDirectoryStream,
        deletePath=delete,
        getOwner,
        setOwner,
        getAttribute,
        setAttribute,
        createTempDirectory,
        createTempFile
    },
    DirectoryNotEmptyException,
    NoSuchFileException
}

interface JavaNIODirectory satisfies Directory {

    shared actual formal ConcretePath path;

    shared actual class TemporaryDirectory(String? prefix)
            extends super.TemporaryDirectory(prefix)
            satisfies JavaNIODirectory {

        JavaNIODirectory delegate = ConcreteDirectory(
                createTempDirectory(outer.path.jpath, prefix));

        name => delegate.name;

        childDirectories(String filter) => delegate.childDirectories(filter);

        childPaths(String filter) => delegate.childPaths(filter);

        childResource(Path|String subpath) => delegate.childResource(subpath);

        children(String filter) => delegate.children(filter);

        delete() => delegate.delete();

        files(String filter) => delegate.files(filter);

        linkedResource => delegate.linkedResource;

        move(Nil target) => delegate.move(target);

        shared actual String owner => delegate.owner;

        assign owner {
            delegate.owner = owner;
        }

        path => delegate.path;

        readAttribute(Attribute attribute) => delegate.readAttribute(attribute);

        writeAttribute(Attribute attribute, Object attributeValue)
                =>  delegate.writeAttribute(attribute, attributeValue);

        deleteOnExit() => delegate.deleteOnExit();

        "Attempt to delete this temporary directory. No action will
         be taken if the directory is not empty or no longer exists."
        shared actual void destroy(Throwable? error) {
            try {
                delete();
            }
            catch (NoSuchFileException | DirectoryNotEmptyException e) {
                // ignore
            }
        }
    }

    shared actual class TemporaryFile(String? prefix, String? suffix)
            extends super.TemporaryFile(prefix, suffix) {

        File delegate = ConcreteFile(
                createTempFile(outer.path.jpath, prefix, suffix));

        contentType => delegate.contentType;

        copy(Nil target, Boolean copyAttributes)
                =>  delegate.copy(target, copyAttributes);

        copyOverwriting(File|Nil target, Boolean copyAttributes)
                =>  delegate.copyOverwriting(target, copyAttributes);

        createLink(Nil target) => delegate.createLink(target);

        createSymbolicLink(Nil target) => delegate.createSymbolicLink(target);

        delete() => delegate.delete();

        directory => delegate.directory;

        executable => delegate.executable;

        hidden => delegate.hidden;

        shared actual Integer lastModifiedMilliseconds
                =>  delegate.lastModifiedMilliseconds;

        assign lastModifiedMilliseconds {
            delegate.lastModifiedMilliseconds = lastModifiedMilliseconds;
        }

        linkedResource => delegate.linkedResource;

        move(Nil target) => delegate.move(target);

        moveOverwriting(File|Nil target) => delegate.moveOverwriting(target);

        name => delegate.name;

        shared actual String owner => delegate.owner;

        assign owner {
            delegate.owner = owner;
        }

        path => delegate.path;

        readAttribute(Attribute attribute) => delegate.readAttribute(attribute);

        readable => delegate.readable;

        size => delegate.size;

        store => delegate.store;

        writable => delegate.writable;

        writeAttribute(Attribute attribute, Object attributeValue)
                =>  delegate.writeAttribute(attribute, attributeValue);

        deleteOnExit() => delegate.deleteOnExit();

        shared actual class Appender(String? encoding, Integer bufferSize)
                extends super.Appender(encoding, bufferSize) {

            value delegate = outer.delegate.Appender(encoding, bufferSize);

            close() => delegate.close();

            flush() => delegate.flush();

            write(String string) => delegate.write(string);

            writeBytes({Byte*} bytes) => delegate.writeBytes(bytes);

            writeLine(String line) => delegate.writeLine(line);
        }

        shared actual class Overwriter(String? encoding, Integer bufferSize)
                extends super.Overwriter(encoding, bufferSize) {

            value delegate = outer.delegate.Overwriter(encoding, bufferSize);

            close() => delegate.close();

            flush() => delegate.flush();

            write(String string) => delegate.write(string);

            writeBytes({Byte*} bytes) => delegate.writeBytes(bytes);

            writeLine(String line) => delegate.writeLine(line);
        }

        shared actual class Reader(String? encoding, Integer bufferSize)
                extends super.Reader(encoding, bufferSize) {

            value delegate = outer.delegate.Reader(encoding, bufferSize);

            close() => delegate.close();

            readBytes(Integer max) => delegate.readBytes(max);

            readLine() => delegate.readLine();
        }

        "Delete this temporary file. No action will be taken
         if the file no longer exists."
        shared actual void destroy(Throwable? error) {
            try {
                delete();
            }
            catch (NoSuchFileException e) {
                // ignore
            }
        }
    }
}

class ConcreteDirectory(JPath jpath)
        satisfies JavaNIODirectory {
    
    shared actual {Path*} childPaths(String filter) {
        try (stream = newDirectoryStream(jpath, filter)) {
            return [for (path in stream) ConcretePath(path)];
        }
    }
    
    path => ConcretePath(jpath); 
    
    linkedResource => this;

    name => jpath.fileName.string;

    children(String filter) =>
           {for (p in childPaths(filter)) 
                 if (is ExistingResource r=p.resource) r};
    
    files(String filter) =>
           {for (p in childPaths(filter))
                 if (is File r=p.resource) r};
    
    childDirectories(String filter) =>
            {for (p in childPaths(filter))
                 if (is Directory r=p.resource) r};
    
    childResource(Path|String subpath) => path.childPath(subpath).resource;
    
    move(Nil target) => ConcreteDirectory( movePath(jpath, asJPath(target.path, jpath)) );
    
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    readAttribute(Attribute attribute) 
            => getAttribute(jpath, attributeName(attribute));
    
    writeAttribute(Attribute attribute, Object attributeValue)
            => setAttribute(jpath, attributeName(attribute), attributeValue);
    
    string => jpath.string;
    
    shared actual String owner => getOwner(jpath).name;
    
    assign owner => setOwner(jpath, jprincipal(jpath, owner));
    
    deleteOnExit() => jpath.toFile().deleteOnExit();
}
