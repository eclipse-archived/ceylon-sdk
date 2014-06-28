import ceylon.file {
    Reader
}

import java.io {
    InputStream,
    BufferedReader,
    InputStreamReader
}

class OutgoingPipe(InputStream stream) 
        satisfies Reader {
    
    value reader = BufferedReader(InputStreamReader(stream));
    
    close() => reader.close();
    
    readLine() => reader.readLine();
    
}