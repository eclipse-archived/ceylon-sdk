import ceylon.file { Path, current }
import ceylon.process { Util { redirectInherit, redirectToAppend, redirectToOverwrite } }

import java.io { OutputStream, OutputStreamWriter, InputStream, 
                 InputStreamReader, BufferedReader, JFile=File }
import java.lang { ProcessBuilder }

shared Process createProcess(Path path=current,
        //Map<String,String>? environment,
        Source? inputSource = null,
        Destination? outputDestination = null,
        Destination? errorDestination = null,
        String... commands) {
    
    value builder = ProcessBuilder();
    builder.command({commands...}...); //TODO: WTF?!
    builder.directory(JFile(path.string));
    
    switch (inputSource)
    case (inheritSource) {
        builder.redirectInput(redirectInherit);
    }
    case (is ReadSource) {
        builder.redirectInput(JFile(inputSource.path.string));
    }
    else {}
    
    switch (outputDestination)
    case (inheritDestination) {
        builder.redirectOutput(redirectInherit);
    }
    case (is AppendDestination) {
        builder.redirectOutput(redirectToAppend(JFile(outputDestination.path.string)));
    }
    case (is OverwriteDestination) {
        builder.redirectOutput(redirectToOverwrite(JFile(outputDestination.path.string)));
    }
    else {}
    
    switch (errorDestination)
    case (inheritDestination) {
        builder.redirectOutput(redirectInherit);
    }
    case (is AppendDestination) {
        builder.redirectError(redirectToAppend(JFile(errorDestination.path.string)));
    }
    case (is OverwriteDestination) {
        builder.redirectError(redirectToOverwrite(JFile(errorDestination.path.string)));
    }
    else {}
    
    value p = builder.start();
    
    class MyPipeSource(OutputStream stream)
            satisfies PipeSource {
        value writer = OutputStreamWriter(stream);
        shared actual void destroy() {
            writer.close();
        }
        shared actual void flush() {}
        shared actual void write(String string) {
            writer.write(string);
        }
        shared actual void writeLine(String line) {
            write(line); write(process.newline);
        }
    
    }
    class MyPipeDestination(InputStream stream) 
            satisfies PipeDestination {
        value reader = BufferedReader(InputStreamReader(stream));
        shared actual void destroy() {
            reader.close();
        }
        shared actual String|Finished readLine() {
            return reader.readLine() else exhausted;
        }
    }
    
    return ConcreteProcess {
        process = p;
        path = path;
        inputSource = inputSource 
                else MyPipeSource(p.outputStream);
        outputDestination = outputDestination 
                else MyPipeDestination(p.inputStream);
        errorDestination = errorDestination 
                else MyPipeDestination(p.errorStream);
        commands = commands;
    };
    
}