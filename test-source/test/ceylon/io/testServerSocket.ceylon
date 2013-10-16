import ceylon.io {
    newServerSocket
}
import ceylon.io.charset {
    byteConsumerToStringConsumer,
    stringToByteProducer,
    ascii
}
import ceylon.test {
    test,
    ignore
}

ignore
test void testServerSocket(){
    value serverSocket = newServerSocket();
    print("Socket is listening at ``serverSocket.localAddress.address``:``serverSocket.localAddress.port``");
    value socket = serverSocket.accept();
    // read it all until EOF
    void echo(String string){
        print(string);
        socket.writeFrom(stringToByteProducer(ascii, string));
    }
    socket.readFully(byteConsumerToStringConsumer(ascii, echo));
    socket.close();
    serverSocket.close();
}