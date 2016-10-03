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
    
    value reader 
            = BufferedReader(InputStreamReader(stream));
    
    close() => reader.close();
    
    readLine() => reader.readLine();
    
    readBytes(Integer max) 
            => let (byteArray = ByteArray(max),
                    size = stream.read(byteArray))
            if (size<0)
                then []
            else if (size==max)
                then (sequence(byteArray.byteArray) else [])
            else byteArray.iterable.take(size).sequence();
}
