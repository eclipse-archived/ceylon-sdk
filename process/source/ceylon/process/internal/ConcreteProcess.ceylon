import ceylon.file { Path, Writer, Reader }
import ceylon.process { stdin=currentInput, stdout=currentOutput, 
                        stderr=currentError,  ...  }
import ceylon.process.internal { Util { redirectInherit, redirectToAppend, 
                                        redirectToOverwrite } }

import java.io { JFile=File }
import java.lang { IllegalThreadStateException, ProcessBuilder, JString=String }

shared class ConcreteProcess(
        path, environment, 
        Input? inputOrNone, 
        Output? outputOrNone, 
        Error? errorOrNone, 
        commands) 
        satisfies Process {

    actual shared Path path;
    actual shared Iterable<String->String> environment;
    actual shared Input|Writer input;
    actual shared Output|Reader output;
    actual shared Error|Reader error;
    actual shared Iterable<String> commands;
    
    value commandArray = { commands... }; //TODO: WTF?!
    value builder = ProcessBuilder();
    builder.command(commandArray...);
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
        builder.redirectInput(redirectInherit);
    }
    case (is FileInput) {
        builder.redirectInput(JFile(inputOrNone.path.string));
    }
    else {}
}

void redirectOutput(Output? outputOrNone, ProcessBuilder builder) {
    switch (outputOrNone)
    case (stdout) {
        builder.redirectOutput(redirectInherit);
    }
    case (is AppendFileOutput) {
        builder.redirectOutput(redirectToAppend(JFile(outputOrNone.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectOutput(redirectToOverwrite(JFile(outputOrNone.path.string)));
    }
    else {}
}

void redirectError(Error? errorOrNone, ProcessBuilder builder) {
    switch (errorOrNone)
    case (stderr) {
        builder.redirectError(redirectInherit);
    }
    case (is AppendFileOutput) {
        builder.redirectError(redirectToAppend(JFile(errorOrNone.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectError(redirectToOverwrite(JFile(errorOrNone.path.string)));
    }
    else {}
}
