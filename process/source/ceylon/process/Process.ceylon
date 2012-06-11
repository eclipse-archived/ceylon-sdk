import ceylon.file { Path, Reader, Writer }

shared interface Process {

    formal shared Path path;
    //shared Map<String,String> environment;
    formal shared Source inputSource;
    formal shared Destination outputDestination;
    formal shared Destination errorDestination;
    formal shared Iterable<String> commands;
    
    formal shared Integer? exitCode;
    formal shared Boolean terminated;
    formal shared Integer? waitForExit();
    formal shared void kill();
    
}

shared interface Source 
        of ReadSource | PipeSource | inheritSource {}

object inheritSource 
        satisfies Source {}

shared interface PipeSource 
        satisfies Source & Writer {}

shared class ReadSource(path) 
        satisfies Source {
    shared Path path;
}

shared interface Destination 
        of OverwriteDestination | AppendDestination | 
           PipeDestination | inheritDestination {}

object inheritDestination 
        satisfies Destination {}

shared interface PipeDestination 
        satisfies Destination & Reader {}

shared class AppendDestination(path) 
        satisfies Destination {
    shared Path path;
}
shared class OverwriteDestination(path) 
        satisfies Destination {
    shared Path path;
}

