Module module {
    name='ceylon.process';
    version='0.3';
    doc = "API for running native commands in a forked process.
           Clients simply create `Process`es using the
           `createProcess()` method.
           
               Process process = createProcess { 
                   path = home;
                   \"ls\"
               };
           
           By default, the standard input, output, and error 
           streams of the new forked process are piped to and
           from the current process by exposing a `Writer` and
           `Reader`s.
           
               if (is Reader reader = process.output) {
                   while (is String line = reader.readLine()) {
                       print(line);
                   }
               }
           
           The standard input, output, and error streams may be
           redirected by specifying an `Input` or `Output` to
           `createProcess()`.
           
               Process process = createProcess { 
                   path = home;
                   OverwriteFileOutput output { 
                       path=home.childPath(\"out.txt\");
                   }
                   AppendFileOutput error { 
                       path=home.childPath(\"err.txt\");
                   }
                   \"ls\"
               };
           
           The objects `currentInput`, `currentOutput`, and 
           `currentError` allow the standard input, output, and 
           error streams to be redirected to the standard input, 
           output, and error streams of the current virtual
           machine process.
           
               Process process = createProcess { 
                   path = home;
                   output = currentOutput;
                   error = currentError;
                   \"ls\"
               };
           
           To wait for the forked process to terminate, call
           the `waitForExit()` method of `Process`.";
    Import { name = 'ceylon.file'; version = '0.3'; }
}