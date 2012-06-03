import ceylon.fs { Reader }
import ceylon.fs.internal { Util { newReader } }
import java.nio.file { JPath=Path }

class ConcreteReader(JPath jpath, String encoding) 
        satisfies Reader {
    value r = newReader(jpath, encoding);
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
