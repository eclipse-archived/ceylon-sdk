import ceylon.io.buffer { ByteBuffer }

"Represents a [[FileDescriptor]] that you can `select`. This means that you can
 register listeners for this file descriptor on a given [[Selector]] object that
 will be called whenever there is data available to be read or written without
 blocking the reading/writing thread."
by("Stéphane Épardaud")
shared interface SelectableFileDescriptor satisfies FileDescriptor {

    "Register a reading listener to the given [[selector]]. The reading listener will
     be invoked by the [[Selector]] whenever data can be read from this file
     descriptor without blocking.
     
     If you are no longer interested in `read` events from the selector, you should return
     `false` from your listener when invoked."
    see(`Selector`)
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

    "Register a writing listener to the given [[selector]]. The writing listener will
     be invoked by the [[Selector]] whenever data can be written to this file
     descriptor without blocking.
     
     If you are no longer interested in `write` events from the selector, you should return
     `false` from your listener when invoked."
    see(`Selector`)
    shared void writeAsync(Selector selector, void producer(ByteBuffer buffer), ByteBuffer buffer = newBuffer()){
        setNonBlocking();
        variable Boolean needNewData = true;
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
                needNewData = false;
            }
            // try to write it
            if(socket.write(buffer) >= 0){
                // did we manage to write everything?
                needNewData = !buffer.hasAvailable;
                return true;
            }else{
                // EOF
                return false;
            }
        }
        selector.addProducer(this, writeData);
    }

    // FIXME: revisit, pull up
    "Sets this file descriptor in `non-blocking` mode."
    shared formal void setNonBlocking();
}
