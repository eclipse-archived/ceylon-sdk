doc "API for running native commands in a child process.
       Clients simply create `Process`es using the
       `createProcess()` method. The new process starts
       executing immediately.
       
           Process process = createProcess { 
               command = \"ls -l\";
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
               command = \"ls -l\";
               path = home;
               OverwriteFileOutput output { 
                   path=home.childPath(\"out.txt\");
               }
               AppendFileOutput error { 
                   path=home.childPath(\"err.txt\");
               }
           };
       
       The objects `currentInput`, `currentOutput`, and 
       `currentError` allow the standard input, output, and 
       error streams to be redirected to the standard input, 
       output, and error streams of the current virtual
       machine process.
       
           Process process = createProcess {
               command = \"ls -l\";
               path = home;
               output = currentOutput;
               error = currentError;
           };
       
       To wait for the child process to terminate, call
       the `waitForExit()` method of `Process`."
by "Gavin King"
module ceylon.process '0.3.3' {
    import ceylon.file '0.3.3';
    import java '7';
}
