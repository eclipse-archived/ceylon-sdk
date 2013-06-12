import java.io { InputStream }
import java.nio { ByteBuffer { allocate } }
import java.lang { JString = String }

"Reads an InputStream of the given length into a String using the specified charset"
by("Stéphane Épardaud")
shared String readString(InputStream stream, Integer length, String charset){
    ByteBuffer total = allocate(length);
    ByteBuffer chunk = allocate(1024);
    variable Integer read;
    while((read = stream.read(chunk.array())) >= 0){
        total.put(chunk.array(), 0, read);
    }
    return JString(total.array(), charset).string;
}