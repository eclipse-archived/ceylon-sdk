import ceylon.io {
    Socket,
    Selector,
    newSelector,
    SocketConnector,
    SocketAddress,
    newSslSocketConnector,
    newSocketConnector,
    SocketTimeoutException
}
import ceylon.io.buffer {
    ...
}
import ceylon.io.charset {
    ...
}
import ceylon.net.uri {
    parse
}
import ceylon.test {
    test,
    assertThatException
}

void readResponse(Socket socket) {
    // blocking read
    value decoder = utf8.Decoder();
    // read,decode it all, blocking
    socket.readFully((ByteBuffer buffer) => decoder.decode(buffer));
    // print it all
    print(decoder.consume());
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
    value decoder = utf8.Decoder();
    // read, decode it all as we get data
    socket.readAsync(select, (ByteBuffer buffer) => decoder.decode(buffer));
    // run the event loop
    select.process();
    // print it all
    print(decoder.consume());
}

T notNull<T>(T? o) given T satisfies Object{
    if(exists o){
        return o;
    }
    throw;
}

void writeRequest(String request, Socket socket) {
    // encode it in one go
    value requestBuffer = ascii.encode(request);
    // write it all, blocking
    socket.writeFully(requestBuffer);
}

void writeRequestInPipeline(String request, Socket socket) {
    // encode it and send it by chunks
    value requestBuffer = newByteBuffer(200);
    value encoder = ascii.Encoder();
    value input = newCharacterBufferWithData(request);
    while(input.hasAvailable){
        encoder.encode(input, requestBuffer);
        // flip and flush the request buffer
        requestBuffer.flip();
        // write it all, blocking
        socket.writeFully(requestBuffer);
        requestBuffer.clear();
    }
}

void writeRequestFromCallback(String request, Socket socket) {
    // encode it and send it by chunks
    value requestBuffer = newByteBuffer(200);
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

test
void connectTimeout() {
    value connector = newSocketConnector(SocketAddress("8.8.8.8", 52496));
    assertThatException(() => connector.connect(1)).hasType(`SocketTimeoutException`);
}
test
void sslConnectTimeout() {
    value connector = newSslSocketConnector(SocketAddress("8.8.8.8", 52496));
    assertThatException(() => connector.connect(1)).hasType(`SocketTimeoutException`);
}

test
void readTimeout() {
    ByteBuffer buf = newByteBuffer(1);
    value connector = newSocketConnector(SocketAddress("example.com", 80));
    value socket = connector.connect(5000, 1);
    assertThatException(() => socket.read(buf)).hasType(`SocketTimeoutException`);
}
test
void sslReadTimeout() {
    ByteBuffer buf = newByteBuffer(1);
    value connector = newSslSocketConnector(SocketAddress("example.com", 443));
    value socket = connector.connect(5000, 1);
    assertThatException(() => socket.read(buf)).hasType(`SocketTimeoutException`);
}
