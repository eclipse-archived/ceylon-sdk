shared interface Writer /*satisfies Closeable*/ {
    shared formal void write(String string);
    shared formal void writeLine(String line);
    shared formal void flush();
    shared formal void close();
}