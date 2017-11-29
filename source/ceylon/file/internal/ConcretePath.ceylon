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
    IOException
}
import java.net {
    URI {
        newURI=create
    }
}
import java.nio.file {
    JPath=Path,
    Paths {
        newPath=get
    },
    FileVisitor,
    FileVisitResult,
    FileSystems {
        defaultFileSystem=default
    },
    Files {
        isDirectory,
        isRegularFile,
        isExisting=\iexists,
        isSymbolicLink,
        walkFileTree
    }
}
import java.nio.file.attribute {
    BasicFileAttributes
}

shared Path parsePath(String pathString) =>
        ConcretePath(newPath(pathString));

shared Path parseUri(String uriString) =>
        ConcretePath(newPath(newURI(uriString)));

shared Path[] rootPaths
        => [ for (path in defaultFileSystem.rootDirectories)
             ConcretePath(path) ];

JPath asJPath(String|Path path, JPath systemPath)
        => if (is ConcretePath path)
        then path.jpath
        else systemPath.fileSystem.getPath(path.string);

class ConcretePath(jpath)
        satisfies Path {
    
    shared JPath jpath;
    
    shared actual ConcretePath parent {
        if (exists jparent = jpath.parent) {
            return ConcretePath(jparent);
        }
        else {
            return this;
        }
    }
    
    childPath(String|Path subpath) =>
            ConcretePath(jpath.resolve(asJPath(subpath, jpath)));
    
    siblingPath(String|Path subpath) =>
            ConcretePath(jpath.resolveSibling(asJPath(subpath, jpath)));
    
    root => jpath.nameCount==0;
    
    absolute => jpath.absolute;
    
    absolutePath => ConcretePath(jpath.toAbsolutePath());
    
    normalizedPath => ConcretePath(jpath.normalize());
    
    parentOf(Path path) => asJPath(path, jpath).startsWith(jpath);
    
    childOf(Path path) => jpath.startsWith(asJPath(path, jpath));
    
    relativePath(String|Path path) =>
            ConcretePath(asJPath(path, jpath).relativize(jpath));
    
    system => ConcreteSystem(jpath.fileSystem);
    
    string => jpath.string;
    
    uriString => jpath.toUri().string;
    
    shared actual Path[] elementPaths
            => [for (path in jpath) ConcretePath(path)];
    
    shared actual String[] elements
            => [for (path in jpath) path.string];
    
    compare(Path other)
            => jpath.compareTo(asJPath(other, jpath)) <=> 0;
    
    equals(Object that)
            => if (is Path that)
            then asJPath(that, jpath)==jpath
            else false;
    
    hash => jpath.hash;
    
    separator => jpath.fileSystem.separator;
    
    shared actual Resource resource {
        if (isExisting(jpath)) {
            // prefer ConcreteFile and ConcreteDirectory; only return a ConcreteLink
            // if it is 1) a link to nowhere, or 2) a link to another link.
            if (isRegularFile(jpath)) {
                return ConcreteFile(jpath);
            }
            else if (isDirectory(jpath)) {
                return ConcreteDirectory(jpath);
            }
            else if (isSymbolicLink(jpath)) {
                return ConcreteLink(jpath);
            }
            else {
                throw Exception("unknown file type: " +
                        jpath.string);
            }
        }
        else if (isSymbolicLink(jpath)) {
            // a symbolic link that does not ultimately resolve
            // to a file or directory.
            return ConcreteLink(jpath);
        }
        else {
            return ConcreteNil(jpath);
        }
    }
    
    shared actual Link? link
        =>  if (isSymbolicLink(jpath))
            then ConcreteLink(jpath)
            else null;
    
    shared actual void visit(Visitor visitor) {
        object fileVisitor satisfies FileVisitor<JPath> {
            value result {
                return visitor.terminated 
                        then FileVisitResult.terminate
                        else FileVisitResult.\icontinue;
            }
            shared actual FileVisitResult preVisitDirectory(JPath? t, 
                    BasicFileAttributes? basicFileAttributes) {
                if (exists t) {
                    return visitor.beforeDirectory(ConcreteDirectory(t)) 
                            then result
                            else FileVisitResult.skipSubtree;
                }
                return result;
            }
            shared actual FileVisitResult postVisitDirectory(JPath? t, 
                    IOException? iOException) {
                if (exists t) {
                    visitor.afterDirectory(ConcreteDirectory(t));
                }
                return result;
            }
            shared actual FileVisitResult visitFile(JPath? t, 
                    BasicFileAttributes? basicFileAttributes) {
                if (exists t) {
                    visitor.file(ConcreteFile(t));
                }
                return result;
            }
            shared actual FileVisitResult visitFileFailed(JPath? t, 
                    IOException? iOException) {
                return result;
            }
        }
        walkFileTree(jpath, fileVisitor);
    }    
    
}
