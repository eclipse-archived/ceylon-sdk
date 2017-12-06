/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.file.internal {
    parsePathInternal=parsePath,
    parseUriInternal=parseUri,
    rootPathsInternal=rootPaths
}

import java.lang {
    S=System {
        getProperty
    }
}

"Represents a path in a hierarchical file system. A 
 path is a sequence of path elements. A path may be 
 an absolute path that begins at the root of the 
 file system, or a relative path."
shared sealed interface Path
        satisfies Comparable<Path> {
    
    "The parent path of this path, formed by 
     removing the last path element, or, if this 
     path is the root path, and has no path elements, 
     this root path."
    shared formal Path parent;
    
    "This path, after appending the given path 
     element."
    shared formal Path childPath(String|Path subpath);
    
    "This path, after removing the last path element,
     and then appending the given path element."
    shared formal Path siblingPath(String|Path subpath);
    
    "This path, converted into an absolute path. If 
     this path is already absolute, return this path.
     Otherwise, if this path is a relative path, 
     resolve it against the file system's default 
     directory."
    shared formal Path absolutePath;
    
    "This path, simplified to a canonical form."
    shared formal Path normalizedPath;
    
    "This path, converted into a path relative to 
     the given path."
    shared formal Path relativePath(String|Path path);
    
    "The path elements of this path, as paths 
     consisting of a single path element."
    shared formal Path[] elementPaths;
    
    "The path elements of this path, as strings."
    shared formal String[] elements;
    
    "Determine if this is an absolute path."
    shared formal Boolean absolute;
    
    "Determine if this is a root path, with no 
     [[elements]]."
    shared formal Boolean root;
    
    "Obtain a `Resource` representing the file or
     directory located at this path.
     
     If a symbolic link exists at this path, and
     the symbolic link ultimately points to a file
     or directory, a `File` or `Directory` resource
     will be returned rather than a `Link` resource."
    shared formal Resource resource;
    
    "Obtain a `Link` representing the symbolic link
     located at this path, or `null` if a symbolic
     link does not exist at this path."
    shared formal Link? link;

    "The `System` this is a path in."
    shared formal System system;
    
    "Determine if this path is a parent of the
     given path."
    shared formal Boolean parentOf(Path path);
    
    "Determine if this path is a child of the
     given path."
    shared formal Boolean childOf(Path path);
    
    "Walk the tree of directories rooted at this 
     path and visit files contained in this
     directory tree."
    shared formal void visit(Visitor visitor);
    
    "The separator character used by this path."
    shared formal String separator;
    
    "This path, expressed as a string."
    shared actual formal String string;
    
    "This path, represented as a URI string."
    shared formal String uriString;
    
}

"Obtain a `Path` in the default file system given 
 the string representation of a path."
see(`value defaultSystem`)
shared Path parsePath(String pathString) => parsePathInternal(pathString);

"Obtain a `Path` given the string representation
 of a URI. The scheme determines the file system
 the path belongs to. The scheme `file:` refers
 to the default file system."
see(`interface System`)
shared Path parseUri(String uriString) => parseUriInternal(uriString);

"Obtain a `Path` given the string representation
 of a URI. The scheme determines the file system
 the path belongs to. The scheme `file:` refers
 to the default file system."
deprecated("Use [[parseUri]]")
shared Path parseURI(String uriString) => parseUri(uriString);

"The `Path` representing the user home directory."
shared Path home = parsePath(getProperty("user.home"));

"The `Path` representing the user current working
 directory."
shared Path current = parsePath(getProperty("user.dir"));

"The `Path`s representing the root directories of
 the default file system."
see(`value defaultSystem`)
shared Path[] rootPaths = rootPathsInternal;

"A file visitor."
shared class Visitor() {
    
    "Called before visiting files and subdirectories
     of the given directory. If this method returns 
     `false`, the files and subdirectories of the given 
     directory will not be visited."
    shared default Boolean beforeDirectory(Directory dir) { return true; }
    
    "Called after visiting files and subdirectories
     of the given directory."
    shared default void afterDirectory(Directory dir) {}
    
    "Visit a file."
    shared default void file(File file) {}
    
    "Evaluates to `true` to indicate that no more
     files or directories should be visited."
    shared default Boolean terminated { return false; }
    
}