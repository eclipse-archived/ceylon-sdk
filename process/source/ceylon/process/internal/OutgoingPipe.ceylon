import ceylon.file { Reader }

import java.io { InputStream, BufferedReader, InputStreamReader }

class OutgoingPipe(InputStream stream) 
        satisfies Reader {
    
    value reader = BufferedReader(InputStreamReader(stream));
    
    shared actual void destroy() {
        reader.close();
    }
    shared actual String? readLine() {
        return reader.readLine();
    }
    
}