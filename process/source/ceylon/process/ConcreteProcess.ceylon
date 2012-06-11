import ceylon.file { Path }

import java.lang { JProcess=Process, IllegalThreadStateException }

shared class ConcreteProcess(process, path, /*environment,*/ 
        inputSource, outputDestination, errorDestination, 
        commands) 
        satisfies Process {

    actual shared Path path;
    //shared Map<String,String> environment;
    actual shared Source inputSource;
    actual shared Destination outputDestination;
    actual shared Destination errorDestination;
    actual shared Iterable<String> commands;
    
    JProcess process;
    
    actual shared Integer? exitCode {
        try {
            return process.exitValue();
        }
        catch (IllegalThreadStateException e) {
            return null;
        }
    }
    
    actual shared Boolean terminated {
        return exitCode exists;
    }
    
    actual shared Integer waitForExit() {
        return process.waitFor();
    }
    
    actual shared void kill() {
        process.destroy();
    }
    
}