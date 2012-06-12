import ceylon.process { ... }
import ceylon.file { Path, Writer, Reader }

import java.lang { JProcess=Process, IllegalThreadStateException }

shared class ConcreteProcess(process, path, environment, 
        input, output, error, commands) 
        satisfies Process {

    actual shared Path path;
    actual shared Iterable<String->String> environment;
    actual shared Input|Writer input;
    actual shared Output|Reader output;
    actual shared Error|Reader error;
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