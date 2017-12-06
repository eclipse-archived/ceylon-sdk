/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"This package lets you create [[FileDescriptor]] objects, 
 which represent open streams, such as files, sockets, or 
 pipes. You can read and write bytes from and to those 
 streams in synchronous or asynchronous mode, using 
 [[Buffer|ceylon.buffer::Buffer]] objects, and you can 
 convert bytes to [[String]] objects using 
 [[Charset|ceylon.buffer.charset::Charset]] objects.
 
 Here's how you can get a [[Socket]] to a remote host in a 
 blocking way:
 
     // connect to example.com on port 80
     value connector = newSocketConnector(SocketAddress(\"example.com\", 80));
     value socket = connector.connect();
 
 Sample usage for reading all the available bytes from a 
 remote socket in a blocking way:
 
     void readResponse(Socket socket) {
         // create a new decoder from ASCII bytes
         Decoder decoder = ascii.newDecoder();
         // read,decode it all, blocking
         socket.readFully((ByteBuffer buffer) => decoder.decode(buffer));
         // print it all
         process.write(decoder.done());
     }
 
 Here's the same code, but in an asynchronous way, using a 
 [[Selector]] object to treat `read` events:
 
     void readResponseAsync(Socket socket) {
         // create a new selector for reading from this socket
         Selector select = newSelector();
         // read, decode, print as we get data
         socket.readAsync(select, byteConsumerToStringConsumer(utf8, (String string) => process.write(string)));
         // run the event loop
         select.process();
     }
 
 Here's how you could write a request to a [[Socket]] in a 
 blocking way:
 
     void writeRequest(String data, Socket socket) {
         // encode it in one go
         value requestBuffer = ascii.encode(data);
         // write it all, blocking
         socket.writeFully(requestBuffer);
     }
 
 Here's how you would write a request to a [[Socket]] in an 
 asynchronous way:
 
     void writeRequestAsync(String request, Socket socket) {
         Selector select = newSelector();
         // encode and write as we can
         socket.writeAsync(select, stringToByteProducer(ascii, request));
         // run the event loop
         select.process();
     }
 
 Finally, here's how you can read and write asynchronously 
 to the same socket:
 
     void readAndWriteAsync(String request, Socket socket) {
         Selector select = newSelector();
         // encode and write as we can
         socket.writeAsync(select, stringToByteProducer(ascii, request));
         // read, decode and print as we can
         socket.readAsync(select, byteConsumerToStringConsumer(utf8, (String string) => process.write(string)));
         // run the event loop
         select.process();
     }
 "
by("Stéphane Épardaud")
shared package ceylon.io;
