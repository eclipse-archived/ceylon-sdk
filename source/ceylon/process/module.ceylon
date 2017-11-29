/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"API for running native commands in a child process.
 Clients simply create `Process`es using the
 `createProcess()` method. The new process starts
 executing immediately.
   
     Process process = createProcess { 
         command = \"ls\";
         arguments = [\"-l\"];
         path = home;
     };
   
 By default, the standard input, output, and error 
 streams of the new child process are piped to and
 from the current process by exposing a `Writer` and
 `Reader`s.
   
     if (is Reader reader = process.output) {
         while (exists line = reader.readLine()) {
             print(line);
         }
     }
   
 The standard input, output, and error streams may be
 redirected by specifying an `Input` or `Output` to
 `createProcess()`.
   
     Process process = createProcess {
         command = \"ls\";
         arguments = [\"-l\"];
         path = home;
         output = OverwriteFileOutput {
             path = home.childPath(\"out.txt\");
         };
         error = AppendFileOutput {
             path = home.childPath(\"err.txt\");
         };
     };
   
 The objects `currentInput`, `currentOutput`, and 
 `currentError` allow the standard input, output, and 
 error streams to be redirected to the standard input, 
 output, and error streams of the current virtual
 machine process.
   
     Process process = createProcess {
         command = \"ls\";
         arguments = [\"-l\"];
         path = home;
         output = currentOutput;
         error = currentError;
     };
   
 To wait for the child process to terminate, call
 the `waitForExit()` method of `Process`."
by("Gavin King")
native("jvm")
label("Ceylon Native Process API")
module ceylon.process maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import ceylon.file "1.3.4-SNAPSHOT";
    import java.base "7";
}
