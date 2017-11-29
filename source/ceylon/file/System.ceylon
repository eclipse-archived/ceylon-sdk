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
    defaultParsePath=parsePath,
    defaultRootPaths=rootPaths,
    defaultStores=stores
}
import ceylon.file.internal {
    internalCreateSystem=createSystem
}

"Represents a special-purpose file system."
shared interface System {
    
    "Obtain a `Path` in this file system given the 
     string representation of a path."
    shared formal Path parsePath(String pathString);
    
    "The `Path`s representing the root directories of
     the file system."
    shared formal Path[] rootPaths;
    
    "The `Store`s belonging to this file system."
    shared formal Store[] stores;
    
    "Determine if this system can be written to."
    shared formal Boolean writeable;
    
    "Close this `System`."
    shared formal void close();

    "Determine if this `System` is open."
    shared formal Boolean open;
    
}

"Create a `System` given a URI and a sequence of 
 named values."
shared System createSystem(
        "The URI, as a string."
        String uriString,
        "A sequence of file system-specific named 
         values." 
        <String->String>* properties) 
        => internalCreateSystem(uriString, *properties);

"Create a `System` for accessing entries in a zip 
 file."
shared System createZipFileSystem(
        "The zip file. If `Nil`, a new zip file
         will be automatically created." 
        File|Nil file, 
        "The character encoding for entry names." 
        String encoding="UTF-8")
        => createSystem("jar:" + file.path.uriString, 
            "create"->(file is Nil).string, 
            "encoding"->encoding);

"A `System` representing the default file system."
shared object defaultSystem 
        satisfies System {
    
    parsePath(String pathString) => defaultParsePath(pathString);
    
    rootPaths => defaultRootPaths;
    
    stores => defaultStores;
    
    open => true;
    
    writeable => true;
    
    shared actual void close() {
        throw Exception("the default system cannot be closed");
    }
    
}