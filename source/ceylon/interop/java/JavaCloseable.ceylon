/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.lang {
    AutoCloseable
}

"A Java [[AutoCloseable]] that adapts an instance of Ceylon's 
 [[Destroyable]], allowing it to be used as a resource in
 the `try` construct."
shared class JavaCloseable<Resource>(shared Resource resource) 
        satisfies AutoCloseable
        given Resource satisfies Destroyable {
    
    close() => resource.destroy(null);
}
