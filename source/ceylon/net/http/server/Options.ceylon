import ceylon.io.charset { utf8, Charset }
by "Matej Lazar"
shared class Options(
        workerIoThreads = 4, 
        workerTaskCoreThreads = 2, 
        workerTaskMaxThreads = 12,
        connectionLowWatter = 1000000,
        connectionHighWatter = 1000000,
        defaultCharset = utf8) {
    shared variable Integer workerIoThreads;
    shared variable Integer workerTaskCoreThreads;
    shared variable Integer workerTaskMaxThreads;
    shared variable Integer connectionLowWatter;
    shared variable Integer connectionHighWatter;
    
    doc "Default charset is used to encode string, when there is no charset header in response.
         Default value is [[utf8]]."
    shared variable Charset defaultCharset;
}
