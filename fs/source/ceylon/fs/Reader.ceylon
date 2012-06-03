shared interface Reader /*satisfies Closeable*/ {
    shared formal String|Finished readLine();
    shared formal void close();
}