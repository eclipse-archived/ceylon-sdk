/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.file {
    Path,
    current,
    Reader,
    Writer
}
import ceylon.process.internal {
    ConcreteProcess,
    environment
}

"Represents a separate native process."
see(`function createProcess`)
shared sealed interface Process {
    
    "A _command_, usually the name or path of 
     a program to execute."
    formal shared String command;
    
    "The arguments to the [[command]]."
    formal shared {String*} arguments;
    
    "The directory in which the process runs."
    formal shared Path path;
    
    "The standard input stream of the process.
     This is a `Writer` in the case that the
     standard input is being piped from the
     current process."
    formal shared Input|Writer input;
    
    "The standard output stream of the process.
     This is a `Reader` in the case that the
     standard output is being piped back to the
     current process."
    formal shared Output|Reader output;
    
    "The standard error stream of the process.
     This is a `Reader` in the case that the
     standard error is being piped back to the
     current process."
    formal shared Error|Reader error;
    
    "The environment variables of the process."
    formal shared Iterable<String->String> environment;
    
    "The exit code of the terminated process,
     or `null` if the process has not yet 
     terminated. Normal termination is 
     conventionally indicated by the exit
     code `0`."
    formal shared Integer? exitCode;
    
    "Determine if the process has terminated."
    formal shared Boolean terminated;
    
    "Wait for the process to terminate, 
     returning the exit code. Normal 
     termination is conventionally indicated 
     by the exit code `0`."
    formal shared Integer waitForExit();
    
    "Force the process to terminate."
    formal shared void kill();
    
}

"Create and start a new process, running the
 given command."
shared Process createProcess(
        "The _command_ to be run in the new 
         process, usually the name or path of a 
         program. Command arguments must be passed
         via the [[arguments]] sequence."
        String command,
        "The arguments to the [[command]]."
        {String*} arguments = {},
        "The directory in which the process runs."
        Path path = current,
        "The source for the standard input stream
         of the process, or `null` if the standard 
         input should be piped from the current 
         process."
        Input? input = null,
        "The destination for the standard output 
         stream of the process, or `null` if the 
         standard output should be piped to the 
         current process."
        Output? output = null,
        "The destination for the standard output 
         stream of the process, or `null` if the 
         standard error should be piped to the 
         current process."
        Error? error = null,
        "Environment variables to pass to the
         process. By default the process inherits 
         the environment variables of the current
         virtual machine process."
        <String->String>* environment) 
        => ConcreteProcess(command, arguments, path, 
            input, output, error, environment);

"A source for the standard input stream of a process."
shared interface Input 
        of FileInput | currentInput {}

"The standard input stream of the current process."
shared object currentInput 
        satisfies Input {}

"A stream that reads standard input from a  file."
shared class FileInput(path) 
        satisfies Input {
    "The path of the file."
    shared Path path;
}

"A destination for the standard output stream  of a process."
shared interface Output
        of AppendFileOutput|OverwriteFileOutput|currentOutput {}

"A destination for the standard error stream of a process."
shared interface Error
        of AppendFileOutput|OverwriteFileOutput|currentError {}

"The standard output stream of the current process."
shared object currentOutput 
        satisfies Output {}

"The standard error stream of the current process."
shared object currentError 
        satisfies Error {}

"A stream that appends standard output or standard error to a file."
shared class AppendFileOutput(path) 
        satisfies Output & Error {
    "The path of the file."
    shared Path path;
}

"A stream that writes standard output or standard error to a file."
shared class OverwriteFileOutput(path) 
        satisfies Output & Error {
    "The path of the file."
    shared Path path;
}

"Environment variables of the current virtual machine process."
shared Iterable<String->String> currentEnvironment 
        => environment;
