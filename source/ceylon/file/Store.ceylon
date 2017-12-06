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
    storesInternal=stores
}

"Represents a file system store."
shared sealed interface Store {
    
    "The total number of bytes that can be
     held by this store."
    shared formal Integer totalSpace;
    
    "The total number of bytes that are 
     available in this store."
    see(`value usableSpace`)
    shared formal Integer availableSpace;
    
    "The total number of bytes that may be
     written to this store by this process,
     taking into account permissions, etc."
    see(`value availableSpace`)
    shared formal Integer usableSpace;
    
    "Determine if this store can be written to."
    shared formal Boolean writable;
    
    "The name of this store."
    shared formal String name;
}

"The `Store`s representing the stores of the
 default file system."
see(`value defaultSystem`)
shared Store[] stores = storesInternal;