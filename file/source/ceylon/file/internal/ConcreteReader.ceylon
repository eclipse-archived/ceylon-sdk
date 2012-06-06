import ceylon.file { Reader }

import java.nio.file { JPath=Path, Files { newBufferedReader } }
import java.nio.charset { Charset }

class ConcreteReader(JPath jpath, Charset charset) 
        satisfies Reader {
    value r = newBufferedReader(jpath, charset);
    //shared actual void open() {}
    shared actual void close(/*Exception? exception*/) {
        r.close();
    }
    shared actual String|Finished readLine() {
        if (exists line=r.readLine()) {
            return line;
        }
        else {
            return exhausted;
        }
    }
}
