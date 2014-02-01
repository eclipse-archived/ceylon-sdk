import ceylon.file {
    Path,
    Writer,
    Reader
}
import ceylon.process {
    stdin=currentInput,
    stdout=currentOutput,
    stderr=currentError,
    ...
}

import java.io {
    JFile=File
}
import java.lang {
    IllegalThreadStateException,
    JString=String,
    ProcessBuilder {
        Redirect
    }
}


shared class ConcreteProcess(
        command, arguments, path, 
        Input? inputOrNone, 
        Output? outputOrNone, 
        Error? errorOrNone, 
        environment) 
        satisfies Process {

    actual shared String command;
    actual shared {String*} arguments;
    actual shared Path path;
    actual shared Input|Writer input;
    actual shared Output|Reader output;
    actual shared Error|Reader error;
    actual shared Iterable<String->String> environment;
    
    value builder = ProcessBuilder(command, *arguments);
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
    
    terminated => exitCode exists;
    
    waitForExit() => process.waitFor();
    
    kill() => process.destroy();
    
}

void redirectInput(Input? inputOrNone, ProcessBuilder builder) {
    switch (inputOrNone)
    case (stdin) {
        builder.redirectInput(Redirect.\iINHERIT);
    }
    case (is FileInput) {
        builder.redirectInput(JFile(inputOrNone.path.string));
    }
    else {}
}

void redirectOutput(Output? outputOrNone, ProcessBuilder builder) {
    switch (outputOrNone)
    case (stdout) {
        builder.redirectOutput(Redirect.\iINHERIT);
    }
    case (is AppendFileOutput) {
        builder.redirectOutput(Redirect.appendTo(JFile(outputOrNone.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectOutput(Redirect.to(JFile(outputOrNone.path.string)));
    }
    else {}
}

void redirectError(Error? errorOrNone, ProcessBuilder builder) {
    switch (errorOrNone)
    case (stderr) {
        builder.redirectError(Redirect.\iINHERIT);
    }
    case (is AppendFileOutput) {
        builder.redirectError(Redirect.appendTo(JFile(errorOrNone.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectError(Redirect.to(JFile(errorOrNone.path.string)));
    }
    else {}
}
