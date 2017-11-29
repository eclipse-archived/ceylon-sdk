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
    Writer
}

import java.io {
    OutputStream,
    OutputStreamWriter
}
import java.lang {
    ByteArray
}

class IncomingPipe(OutputStream stream)
        satisfies Writer {
    
    value writer = OutputStreamWriter(stream);
    
    close() => writer.close();
    
    flush() => writer.flush();
    
    write(String string) => writer.write(string);
    
    shared actual void writeLine(String line) {
        write(line); 
        write(operatingSystem.newline);
    }
    
    shared actual void writeBytes({Byte*} bytes) {
        value byteArray = ByteArray(bytes.size);
        variable value i=0;
        for (b in bytes) {
            byteArray[i++] = b;
        }
        stream.write(byteArray);
    }
    
}