/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Options for static file endpoints."
see (`function serveStaticFile`)
by("Matej Lazar")
shared class Options(outputBufferSize=8192, readAttempts=10) {
    "size of output buffer"
    shared Integer outputBufferSize;
    "abort reading after n unsuccessful attempts"
    shared Integer readAttempts;
}