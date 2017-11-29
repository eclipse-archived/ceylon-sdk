/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.io.impl {
    InputStreamAdapter,
    OutputStreamAdapter
}

import java.lang {
    System {
        javaIn=\iin,
        javaOut=\iout,
        javaErr=err
    }
}

"A [[ReadableFileDescriptor]] for the virtual machine's standard input stream."
aliased("stdin")
shared ReadableFileDescriptor standardInput = InputStreamAdapter(javaIn);

"A [[WritableFileDescriptor]] for the virtual machine's standard output stream."
aliased("stdout")
shared WritableFileDescriptor standardOutput = OutputStreamAdapter(javaOut);

"A [[WritableFileDescriptor]] for the virtual machine's standard error stream."
aliased("stderr")
shared WritableFileDescriptor standardError = OutputStreamAdapter(javaErr);
