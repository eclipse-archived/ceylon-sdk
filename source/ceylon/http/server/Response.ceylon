/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer {
    ByteBuffer
}
import ceylon.http.common {
    Header
}
import ceylon.io {
    OpenFile
}

"An object to assist sending response to the client."
by("Matej Lazar")
shared interface Response {

    "Writes string to the response."
    shared formal void writeString(String string);

    shared formal void writeStringAsynchronous(
        String string, 
        void onCompletion() => noop(),
        void onError(ServerException e) => noop(e));

    "Writes bytes to the response."
    shared formal void writeBytes(Array<Byte> bytes);

    shared formal void writeBytesAsynchronous(
        Array<Byte> bytes,
        void onCompletion() => noop(),
        void onError(ServerException e) => noop(e));

    "Writes ByteBuffer to the response."
    shared formal void writeByteBuffer(ByteBuffer buffer);

    shared formal void writeByteBufferAsynchronous(
        ByteBuffer byteBuffer,
        void onCompletion() => noop(),
        void onError(ServerException e) => noop(e));

    "Add a header to response. Multiple headers can have the same name.
     Throws Exception if headers have been already sent to client."
    shared formal void addHeader(Header header);

    shared formal void transferFile(OpenFile openFile);
    shared formal void transferFileAsynchronous(
        OpenFile openFile,
        void onCompletion(),
        void onError(ServerException e));

    "The HTTP status code of the response."
    deprecated("Use [[status]]")
    shared formal variable Integer responseStatus;
    
    "The HTTP status code of the response."
    shared formal variable Integer status;

    shared formal void flush();
    shared formal void close();
}
