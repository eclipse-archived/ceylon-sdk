/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Reads lines of text from a `File`."
see(`interface File`)
shared interface Reader 
        satisfies Destroyable {
    
    "The next line of text in the file,
     or `null` if there is no more text
     in the file."
    shared formal String? readLine();
    
    shared formal Byte[] readBytes(Integer max);
    
    "Destroy this `Reader`. Called
     automatically by `destroy()`."
    see(`function destroy`)
    shared formal void close();
    
    shared actual void destroy(Throwable? exception) =>
            close();
    
}