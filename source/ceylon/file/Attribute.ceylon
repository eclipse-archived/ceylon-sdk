/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.nio.file.attribute {
    BasicFileAttributeView,
    PosixFileAttributeView,
    DosFileAttributeView
}

"""A view-name, attribute-name pair that identifies a file
   system attribute, for example `["dos", "hidden"]`,
   `["posix", "group"]`, `["unix", "uid"]`, or 
   `["basic", "lastAccessTime"]`."""
see (`interface BasicFileAttributeView`)
see (`interface PosixFileAttributeView`)
see (`interface DosFileAttributeView`)
shared alias Attribute => [String,String];