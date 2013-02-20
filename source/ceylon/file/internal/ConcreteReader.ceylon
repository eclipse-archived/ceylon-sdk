import ceylon.file { Reader }

import java.nio.file { JPath=Path, Files { newBufferedReader } }
import java.nio.charset { Charset }

class ConcreteReader(JPath jpath, Charset charset) 
        satisfies Reader {
    
    value r = newBufferedReader(jpath, charset);
    
    readLine() => r.readLine();
    
    destroy() => r.close();
    
}
