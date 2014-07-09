"outputBufferSize: size of output buffer
 readAttempts: abort reading after n unsuccessful attempts"
by("Matej Lazar")
shared class Options( 
        outputBufferSize = 8192,
        readAttempts = 10 
    ) {

    shared Integer outputBufferSize;
    shared Integer readAttempts;
}