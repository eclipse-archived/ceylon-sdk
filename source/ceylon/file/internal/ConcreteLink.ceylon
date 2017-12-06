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
        readSymbolicLink,
        deletePath=delete,
        isDirectory,
        isRegularFile,
        notExists,
        getOwner,
        setOwner,
        getAttribute,
        setAttribute
    }
}

class ConcreteLink(JPath jpath)
        satisfies Link {
    
    linkedPath => ConcretePath(jpath.resolveSibling(readSymbolicLink(jpath)));
    
    path => ConcretePath(jpath); 
    
    shared actual File|Directory|Nil linkedResource {
        if (isDirectory(jpath) || isRegularFile(jpath) || notExists(jpath)) {
            // this link ultimately resolves to a file, directory, or nil,
            // so there is no risk of infinite recursion.
            return linkedPath.resource.linkedResource;
        }
        throw Exception("unable to resolve link '``this``' due to cycle.");
    }
    
    readAttribute(Attribute attribute) 
            => getAttribute(jpath, attributeName(attribute));
    
    writeAttribute(Attribute attribute, Object attributeValue)
            => setAttribute(jpath, attributeName(attribute), attributeValue);
    
    string => jpath.string;
    
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    shared actual String owner => getOwner(jpath).name;
        
    assign owner => setOwner(jpath, jprincipal(jpath,owner));
    
    deleteOnExit() => jpath.toFile().deleteOnExit();
}