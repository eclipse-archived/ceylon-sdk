import ceylon.io {
    Socket,
    Selector,
    newSelector,
    SocketConnector,
    SocketAddress,
    newSslSocketConnector,
    byteConsumerToStringConsumer,
    stringToByteProducer
}
import ceylon.buffer {
    ...
}
import ceylon.buffer.charset {
    utf8,
    ascii
}
import ceylon.net.uri {
    parse
}

void readResponse(Socket socket) {
    // blocking read
    value decoder = utf8.cumulativeDecoder();
    // read,decode it all, blocking
    socket.readFully((ByteBuffer buffer) => decoder.more(buffer));
    // print it all
    print(decoder.done().string);
}

void readAsyncResponse2(Socket socket){
    Selector select = newSelector();
    // read, decode, print as we get data
    socket.readAsync(select, byteConsumerToStringConsumer(utf8, (String string) => process.write(string)));
    // run the event loop
    select.process();
    print("");
}

void readAsyncResponse(Socket socket){
    Selector select = newSelector();
    value decoder = utf8.cumulativeDecoder();
    // read, decode it all as we get data
    socket.readAsync(select, (ByteBuffer buffer) => decoder.more(buffer));
    // run the event loop
    select.process();
    // print it all
    print(decoder.done().string);
}

T notNull<T>(T? o) given T satisfies Object{
    if(exists o){
        return o;
    }
    throw;
}

void writeRequest(String request, Socket socket) {
    // encode it in one go
    value requestBuffer = ascii.encodeBuffer(request);
    // write it all, blocking
    socket.writeFully(requestBuffer);
}

void writeRequestInPipeline(String request, Socket socket) {
    // encode it and send it by chunks
    value requestBuffer = ByteBuffer.ofSize(200);
    value encoder = ascii.chunkEncoder();
    value input = CharacterBuffer(request);
    while(input.hasAvailable || !encoder.done){
        encoder.convert(requestBuffer, input);
        // flip and flush the request buffer
        requestBuffer.flip();
        // write it all, blocking
        socket.writeFully(requestBuffer);
        requestBuffer.clear();
    }
}

void writeRequestFromCallback(String request, Socket socket) {
    // encode it and send it by chunks
    value requestBuffer = ByteBuffer.ofSize(200);
    socket.writeFrom(stringToByteProducer(ascii, request), requestBuffer);
}

void writeAsyncRequest(String request, Socket socket){
    Selector select = newSelector();
    // encode and write as we can
    socket.writeAsync(select, stringToByteProducer(ascii, request));
    // run the event loop
    select.process();
}

void readAndWriteAsync(String request, Socket socket){
    Selector select = newSelector();
    // encode and write as we can
    socket.writeAsync(select, stringToByteProducer(ascii, request));
    // read, decode and print as we can
    socket.readAsync(select, byteConsumerToStringConsumer(utf8, (String string) => process.write(string)));
    // run the event loop
    select.process();
    socket.close();
    print("Done read/write");
}

void connectReadAndWriteAsync(String request, SocketConnector connector){
    Selector select = newSelector();
    connector.connectAsync { 
        selector = select; 
        void connect(Socket socket) {
            readAndWriteAsync(request, socket); 
        }
    };
    // run the event loop
    select.process();
    connector.close();
    print("Done connect/read/write");
}


void testGrrr(){
    // /wiki/Chunked_transfer_encoding in thai
    //value uri = parse("http://th.wikipedia.org/wiki/%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A3%E0%B8%AB%E0%B8%B1%E0%B8%AA%E0%B8%82%E0%B8%99%E0%B8%AA%E0%B9%88%E0%B8%87%E0%B9%80%E0%B8%9B%E0%B9%87%E0%B8%99%E0%B8%8A%E0%B8%B4%E0%B9%89%E0%B8%99%E0%B8%AA%E0%B9%88%E0%B8%A7%E0%B8%99");
    value uri = parse("https://api.github.com/repos/ceylon/ceylon-compiler");
    value host = notNull(uri.authority.host);
    value connector = newSslSocketConnector(SocketAddress(host, 443));
    value socket = connector.connect();
    print("Getting ``uri.humanRepresentation``");
    value request = "GET ``uri.path.string`` HTTP/1.1
                     Host: ``host``
                     User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11
                     
                     ";
    print(request);
    
    print("Writing request");
    writeRequest(request, socket);
    //writeAsyncRequest(request, socket);
    
    print("Reading response");
    readResponse(socket);

    //connectReadAndWriteAsync(request, connector);
    //readAndWriteAsync(request, socket);

    socket.close();
}