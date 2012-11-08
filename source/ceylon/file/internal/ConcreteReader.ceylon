import ceylon.file { Reader }

import java.nio.file { JPath=Path, Files { newBufferedReader } }
import java.nio.charset { Charset }

class ConcreteReader(JPath jpath, Charset charset) 
        satisfies Reader {
    value r = newBufferedReader(jpath, charset);
    shared actual String? readLine() {
        return r.readLine();
    }
    shared actual void destroy() {
        r.close();
    }
}
