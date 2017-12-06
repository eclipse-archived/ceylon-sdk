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
    Resource
}
import ceylon.io {
    FileDescriptor
}
import ceylon.io.impl {
    OpenFileImpl
}

"Represents a file object we can read from and write to."
see(`function newOpenFile`)
shared sealed interface OpenFile 
        satisfies FileDescriptor {

    "Returns the [[Resource]] object that contains metadata 
     about this open resource."
    shared formal Resource resource;

    "The current position within this open file. The 
     position is used to indicate where read/writes will 
     start, and increases on every read/write operation that 
     successfully completes."
    shared formal variable Integer position;
    
    "The current size of this open file."
    shared formal Integer size;
    
    "Truncates this open file to the given [[size]]. The new 
     `size` has to be smaller than the current `size`."
    // FIXME: should this be the setter for `size`?
    // due to the semantics of truncate (only works if smaller) 
    // this is not clear:
    // if we call truncate with a larger than size param, 
    // the size will not change unless we also write there 
    shared formal void truncate(Integer size);

    "The platform-specific implementation object, if any."
    shared formal Object? implementation;
}


"Creates a new [[OpenFile]] to read/write to the given 
 [[resource]]."
see(`interface OpenFile`)
shared OpenFile newOpenFile(Resource resource)
        => OpenFileImpl(resource);
