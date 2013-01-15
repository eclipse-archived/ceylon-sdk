import ceylon.file { Path, Writer, Reader }
import ceylon.process { stdin=currentInput, stdout=currentOutput, 
                        stderr=currentError,  ...  }

import java.io { JFile=File }
import java.lang { IllegalThreadStateException, JString=String, 
                   ProcessBuilder { Redirect { appendTo, to, INHERIT } } }

shared class ConcreteProcess(
        command, path, 
        Input? inputOrNone, 
        Output? outputOrNone, 
        Error? errorOrNone, 
        environment) 
        satisfies Process {

    actual shared String command;
    actual shared Path path;
    actual shared Input|Writer input;
    actual shared Output|Reader output;
    actual shared Error|Reader error;
    actual shared Iterable<String->String> environment;
    
    value builder = ProcessBuilder(*command.split().sequence);
    builder.directory(JFile(path.string));
    for (e in environment) {
        builder.environment()
                .put(JString(e.key), JString(e.item));
    }
    
    redirectInput(inputOrNone, builder);
    redirectOutput(outputOrNone, builder);
    redirectError(errorOrNone, builder);
    
    value process = builder.start();
    
    input = inputOrNone
            else IncomingPipe(process.outputStream);
    output = outputOrNone
            else OutgoingPipe(process.inputStream);
    error = errorOrNone
            else OutgoingPipe(process.errorStream);
    
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

void redirectInput(Input? inputOrNone, ProcessBuilder builder) {
    switch (inputOrNone)
    case (stdin) {
        builder.redirectInput(\iINHERIT);
    }
    case (is FileInput) {
        builder.redirectInput(JFile(inputOrNone.path.string));
    }
    else {}
}

void redirectOutput(Output? outputOrNone, ProcessBuilder builder) {
    switch (outputOrNone)
    case (stdout) {
        builder.redirectOutput(\iINHERIT);
    }
    case (is AppendFileOutput) {
        builder.redirectOutput(appendTo(JFile(outputOrNone.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectOutput(to(JFile(outputOrNone.path.string)));
    }
    else {}
}

void redirectError(Error? errorOrNone, ProcessBuilder builder) {
    switch (errorOrNone)
    case (stderr) {
        builder.redirectError(\iINHERIT);
    }
    case (is AppendFileOutput) {
        builder.redirectError(appendTo(JFile(errorOrNone.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectError(to(JFile(errorOrNone.path.string)));
    }
    else {}
}
