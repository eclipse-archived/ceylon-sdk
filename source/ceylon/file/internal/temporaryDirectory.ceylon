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
    Directory
}

shared Directory temporaryDirectory() {
    value tempDirString = process.propertyValue("java.io.tmpdir");
    if (!exists tempDirString) {
        throw AssertionError(
            "Cannot determine system temporary directory path; \
             system property 'java.io.tmpdir' is not set.");
    }
    value directory = parsePath(tempDirString).resource.linkedResource;
    if (!is Directory directory) {
        throw AssertionError(
            "Configured temporary directory path '``tempDirString``'
             is not a directory; please check system property
             'java.io.tmpdir'.");
    }
    return directory;
}
