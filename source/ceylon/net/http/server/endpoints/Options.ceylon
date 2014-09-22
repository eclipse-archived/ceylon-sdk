"Options for static file endpoints."
see (`function serveStaticFile`)
by("Matej Lazar")
shared class Options(outputBufferSize=8192, readAttempts=10) {
    "size of output buffer"
    shared Integer outputBufferSize;
    "abort reading after n unsuccessful attempts"
    shared Integer readAttempts;
}