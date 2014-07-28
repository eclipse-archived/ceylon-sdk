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
    
    value reader = BufferedReader(InputStreamReader(stream));
    
    close() => reader.close();
    
    readLine() => reader.readLine();
    
    shared actual Byte[] readBytes(Integer max) {
        value byteArray = ByteArray(max);
        value size = stream.read(byteArray);
        if (size==max) {
            return sequence(byteArray.byteArray) else [];
        }
        else {
            return [ for (b in byteArray.iterable) b ];
        }
    }
    
}