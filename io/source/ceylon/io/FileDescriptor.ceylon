import ceylon.io.buffer { ByteBuffer }

shared abstract class FileDescriptor() {

    shared formal Integer read(ByteBuffer buffer);
    
    shared void readFully(void consume(ByteBuffer buffer), ByteBuffer buffer = newBuffer()){
        // FIXME: should we allocate the buffer ourselves?
        // FIXME: should we clear the buffer passed?
        // I guess not, because there might be something left by the consumer at the beginning that we don't want to override?
        // FIXME: should we check that the FD is in blocking mode? 
        while(read(buffer) >= 0){
            buffer.flip();
            consume(buffer);
            // FIXME: should we clear the buffer or should the consumer do it?
            // I suppose the consumer should do it, because he might find it convenient to leave something that he couldn't consume?
            // In which case we should probably not try to read if the buffer is still full?
            // OTOH we could require him to consume it all
            buffer.clear();
        }
    }
    
    shared formal Integer write(ByteBuffer buffer);

    shared void writeFully(ByteBuffer buffer){
        while(buffer.hasAvailable
            && write(buffer) >= 0){
        }
    }
    
    shared void writeFrom(void producer(ByteBuffer buffer), ByteBuffer buffer = newBuffer()){
        // refill
        while(true){
            // fill our buffer
            producer(buffer);
            // flip it for reading
            buffer.flip();
            if(!buffer.hasAvailable){
                // EOI
                return;
            }
            writeFully(buffer);
            buffer.clear();
        }
    }
    

    shared formal void close();
}