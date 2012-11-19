import ceylon.file { Path, current, Reader, Writer }
import ceylon.process.internal { ConcreteProcess, environment }

doc "Represents a separate native process."
see (createProcess)
shared interface Process {
    
    doc "A _command_, usually a program with a list
         of its arguments."
    formal shared String command;
    
    doc "The directory in which the process runs."
    formal shared Path path;
    
    doc "The standard input stream of the process.
         This is a `Writer` in the case that the
         standard input is being piped from the
         current process."
    formal shared Input|Writer input;
    
    doc "The standard output stream of the process.
         This is a `Reader` in the case that the
         standard output is being piped back to the
         current process."
    formal shared Output|Reader output;
    
    doc "The standard error stream of the process.
         This is a `Reader` in the case that the
         standard error is being piped back to the
         current process."
    formal shared Error|Reader error;
    
    doc "The environment variables of the process."
    formal shared Iterable<String->String> environment;
    
    doc "The exit code of the terminated process,
         or `null` if the process has not yet 
         terminated."
    formal shared Integer? exitCode;
    
    doc "Determine if the process has terminated."
    formal shared Boolean terminated;
    
    doc "Wait for the process to terminate."
    formal shared Integer waitForExit();
    
    doc "Force the process to terminate."
    formal shared void kill();
    
}

doc "Create and start a new process, running the
     given command."
shared Process createProcess(
        doc "The _command_ to be run in the new 
             process, usually a program with a list 
             of its arguments."
        String command,
        doc "The directory in which the process runs."
        Path path=current,
        doc "The source for the standard input stream
             of the process, or `null` if the standard 
             input should be piped from the current 
             process."
        Input? input = null,
        doc "The destination for the standard output 
             stream ofthe process, or `null` if the 
             standard output should be piped to the 
             current process."
        Output? output = null,
        doc "The destination for the standard output 
             stream ofthe process, or `null` if the 
             standard error should be piped to the 
             current process."
        Error? error = null,
        doc "Environment variables to pass to the
             process. By default the process inherits 
             the environment variables of the current
             virtual machine process."
        String->String... environment) => ConcreteProcess(command, path, input, output, error, environment);

doc "A source for the standard input stream of
     a process."
shared interface Input 
        of FileInput | currentInput {}

doc "The standard input stream of the current
     process."
shared object currentInput 
        satisfies Input {}

doc "A stream that reads standard input from a 
     file."
shared class FileInput(path) 
        satisfies Input {
    doc "The path of the file."
    shared Path path;
}

doc "A destination for the standard output stream 
     of a process."
shared interface Output
        of AppendFileOutput|OverwriteFileOutput|currentOutput {}

doc "A destination for the standard error stream 
     of a process."
shared interface Error
        of AppendFileOutput|OverwriteFileOutput|currentError {}

doc "The standard output stream of the current
     process."
shared object currentOutput 
        satisfies Output {}

doc "The standard error stream of the current
     process."
shared object currentError 
        satisfies Error {}

doc "A stream that appends standard output or 
     standard error to a file."
shared class AppendFileOutput(path) 
        satisfies Output & Error {
    doc "The path of the file."
    shared Path path;
}

doc "A stream that writes standard output or 
     standard error to a file."
shared class OverwriteFileOutput(path) 
        satisfies Output & Error {
    doc "The path of the file."
    shared Path path;
}

doc "Environment variables of the current virtual 
     machine process."
shared Iterable<String->String> currentEnvironment 
         = environment;
