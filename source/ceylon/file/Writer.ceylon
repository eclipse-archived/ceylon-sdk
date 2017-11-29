/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Writes text to a `File`."
see(`interface File`)
shared interface Writer 
        satisfies Destroyable {
    
    "Write text to the file."
    shared formal void write(String string);
    
    "Write a line of text to the file."
    shared formal void writeLine(String line = "");
    
    "Write the given bytes to the file."
    shared formal void writeBytes({Byte*} bytes);
    
    "Flush all written text to the underlying
     file system."
    shared formal void flush();
    
    "Close this `Writer`. Called 
     automatically by `destroy()`."
    see(`function destroy`)
    shared formal void close();

    "Closes this `Writer` after `flush` is called automatically."
    shared actual void destroy(Throwable? exception) =>
            close();
    
}
