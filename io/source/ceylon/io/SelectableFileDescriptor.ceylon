import ceylon.io.buffer { ByteBuffer }

shared abstract class SelectableFileDescriptor() extends FileDescriptor() {

    shared void readAsync(Selector selector, void consume(ByteBuffer buffer), ByteBuffer buffer = newBuffer()){
        setNonBlocking();
        Boolean readData(FileDescriptor socket){
            buffer.clear();
            if(socket.read(buffer) >= 0){
                buffer.flip();
                // FIXME: should the consumer be allowed to stop us?
                print("Calling consumer");
                consume(buffer);
                return true;
            }else{
                // EOF
                return false;
            }
        }
        selector.addConsumer(this, readData);
    }

    shared void writeAsync(Selector selector, void producer(ByteBuffer buffer), ByteBuffer buffer = newBuffer()){
        setNonBlocking();
        variable Boolean needNewData := true;
        Boolean writeData(FileDescriptor socket){
            // get new data if we ran out
            if(needNewData){
                buffer.clear();
                producer(buffer);
                // flip it for reading
                buffer.flip();
                if(!buffer.hasAvailable){
                    // EOI
                    return false;
                }
                needNewData := false;
            }
            // try to write it
            if(socket.write(buffer) >= 0){
                // did we manage to write everything?
                needNewData := !buffer.hasAvailable;
                return true;
            }else{
                // EOF
                return false;
            }
        }
        selector.addProducer(this, writeData);
    }

    shared formal void setNonBlocking();
}
