import ceylon.file { Path, current, Writer, Reader }
import ceylon.process { stdin=currentInput, stdout=currentOutput, stderr=currentError, ... }
import ceylon.process.internal { Util { redirectInherit, redirectToAppend, redirectToOverwrite } }

import java.io { OutputStream, OutputStreamWriter, InputStream, 
                 InputStreamReader, BufferedReader, JFile=File }
import java.lang { ProcessBuilder }

shared Process createProcess(
        Path path,
        //Map<String,String>? environment,
        Input? input,
        Output? output,
        Error? error,
        String... commands) {
    
    value builder = ProcessBuilder();
    builder.command({commands...}...); //TODO: WTF?!
    builder.directory(JFile(path.string));
    
    switch (input)
    case (stdin) {
        builder.redirectInput(redirectInherit);
    }
    case (is FileInput) {
        builder.redirectInput(JFile(input.path.string));
    }
    else {}
    
    switch (output)
    case (stdout) {
        builder.redirectOutput(redirectInherit);
    }
    case (is AppendFileOutput) {
        builder.redirectOutput(redirectToAppend(JFile(output.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectOutput(redirectToOverwrite(JFile(output.path.string)));
    }
    else {}
    
    switch (error)
    case (stderr) {
        builder.redirectOutput(redirectInherit);
    }
    case (is AppendFileOutput) {
        builder.redirectError(redirectToAppend(JFile(error.path.string)));
    }
    case (is OverwriteFileOutput) {
        builder.redirectError(redirectToOverwrite(JFile(error.path.string)));
    }
    else {}
    
    value newProcess = builder.start();
    
    class IncomingPipe(OutputStream stream)
            satisfies Writer {
        value writer = OutputStreamWriter(stream);
        shared actual void destroy() {
            writer.close();
        }
        shared actual void flush() {
            writer.flush();
        }
        shared actual void write(String string) {
            writer.write(string);
        }
        shared actual void writeLine(String line) {
            write(line); write(process.newline);
        }
    
    }
    class OutgoingPipe(InputStream stream) 
            satisfies Reader {
        value reader = BufferedReader(InputStreamReader(stream));
        shared actual void destroy() {
            reader.close();
        }
        shared actual String|Finished readLine() {
            return reader.readLine() else exhausted;
        }
    }
    
    return ConcreteProcess {
        process = newProcess;
        path = path;
        input = input 
                else IncomingPipe(newProcess.outputStream);
        output = output 
                else OutgoingPipe(newProcess.inputStream);
        error = error 
                else OutgoingPipe(newProcess.errorStream);
        commands = commands;
    };
    
}