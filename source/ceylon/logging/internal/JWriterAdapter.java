package ceylon.logging.internal;

import java.io.IOException;
import java.io.Writer;

public abstract class JWriterAdapter extends Writer {
    
    public abstract void writeCBuff(char[] cbuf, Integer off, Integer len);
    
    public void write(char[] cbuf, int off, int len) throws IOException {
        writeCBuff(cbuf, off, len);
    }
    
    @Override
    public Writer append(char c) throws IOException {
        return super.append(c);
    }
}
