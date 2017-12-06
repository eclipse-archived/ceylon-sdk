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
    Store
}

import java.nio.file {
    JFileStore=FileStore,
    FileSystems {
        defaultFileSystem=default
    }
}

shared Store[] stores
        => [ for (store in defaultFileSystem.fileStores)
             ConcreteStore(store) ];

class ConcreteStore(JFileStore jstore) 
        satisfies Store {
    
    totalSpace => jstore.totalSpace;
    
    availableSpace => jstore.unallocatedSpace;
    
    usableSpace => jstore.usableSpace;
    
    name => jstore.name();
    
    writable => !jstore.readOnly;
    
}