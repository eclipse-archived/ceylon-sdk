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
        newDirectory=createDirectory,
        newDirectories=createDirectories,
        newFile=createFile,
        newSymbolicLink=createSymbolicLink
    }
}

class ConcreteNil(JPath jpath) 
        satisfies Nil {
    
    createDirectory(Boolean includingParentDirectories) 
            => if (includingParentDirectories) 
            then ConcreteDirectory(newDirectories(jpath)) 
            else ConcreteDirectory(newDirectory(jpath));
    
    shared actual File createFile
            (Boolean includingParentDirectories) {
        if (includingParentDirectories, 
            exists parent = jpath.parent) {
            newDirectories(parent);
        }
        return ConcreteFile(newFile(jpath));
    }
    
    shared actual Link createSymbolicLink
            (Path linkedPath, Boolean includingParentDirectories) {
        if (includingParentDirectories,
            exists parent = jpath.parent) {
            newDirectories(parent);
        }
        assert (is ConcretePath linkedPath);
        return ConcreteLink(newSymbolicLink(jpath, linkedPath.jpath));
    }

    path => ConcretePath(jpath); 
    
    linkedResource => this;
    
}