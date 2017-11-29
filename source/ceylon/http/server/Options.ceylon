/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer.charset {
    utf8,
    Charset
}

"Options for starting a [[Server]]."
see (`function Server.start`, 
     `function Server.startInBackground`)
by("Matej Lazar")
shared class Options(
        workerIoThreads = 4, //TODO cpuCount x 2
        workerTaskCoreThreads = 2, 
        workerTaskMaxThreads = 12,
        connectionLowWatter = 1000000,
        connectionHighWatter = 1000000,
        defaultCharset = utf8,
        sessionId = "ceylon-http-server-session") {
    shared variable Integer workerIoThreads;
    shared variable Integer workerTaskCoreThreads;
    shared variable Integer workerTaskMaxThreads;
    shared variable Integer connectionLowWatter;
    shared variable Integer connectionHighWatter;
    
    "Default charset is used to encode string, when there is 
     no charset header in response. Default to [[utf8]]."
    shared variable Charset defaultCharset;
    shared variable String sessionId;
}
