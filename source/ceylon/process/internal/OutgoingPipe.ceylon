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
    Reader
}

import java.io {
    InputStream,
    BufferedReader,
    InputStreamReader
}
import java.lang {
    ByteArray
}

class OutgoingPipe(InputStream stream) 
        satisfies Reader {
    
    value reader 
            = BufferedReader(InputStreamReader(stream));
    
    close() => reader.close();
    
    readLine() => reader.readLine();
    
    readBytes(Integer max) 
            => let (byteArray = ByteArray(max),
                    size = stream.read(byteArray))
            if (size<=0)
                then []
            else if (size==max)
                then byteArray.byteArray.sequence()
            else byteArray.iterable.take(size).sequence();
}
