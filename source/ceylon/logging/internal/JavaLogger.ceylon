import ceylon.logging { Level, Logger, levelTrace, levelDebug, levelInfo, levelWarn, levelError, levelFatal }
import org.jboss.logmanager { LogManager = Logger {manager = getLogger}}
import org.jboss.logmanager.handlers { WriterHandler }
import java.lang { CharArray, JInteger = Integer }
import java.io {JWriter = Writer}
import java.util.logging { JLevel = Level }
import ceylon.logging.internal { JLevelAdapter }
import org.jboss.logmanager.formatters { PatternFormatter }
import ceylon.logging.writer { Writer }

by ("Matej Lazar")
shared class JavaLogger(String name, Level level, Writer writer) extends Logger(name, level, writer) {

    LogManager logManager = manager(name);

    logManager.setLevelName(level.string.uppercased);
    logManager.level = translateLevel(level);
    
    WriterHandler handler = WriterHandler();
    handler.setWriter(wrapWritter(writer));
    //TODO use ceylon formater
    handler.setFormatter(PatternFormatter("%d{HH:mm:ss,SSS} %-5p [%c{1}] %m%n"));
    logManager.addHandler(handler);

    shared actual void log(Level level, String message) {
        if (this.level <= level ) {
            writer.write(message);//TODO log warning "Do not use Java logger in Ceylon code."
        }
    }
}

JLevel translateLevel(Level level) { 
    switch (level)
    case (levelFatal) {
        return JLevelAdapter(level.string, 1100);
    }
    case (levelError) {
        return JLevelAdapter(level.string, 1000); 
    }
    case (levelWarn) {
        return JLevelAdapter(level.string, 900);
    }
    case (levelInfo) {
        return JLevelAdapter(level.string, 800);
    }
    case (levelDebug) {
        return JLevelAdapter(level.string, 500);
    }
    case (levelTrace) {
        return JLevelAdapter(level.string, 0);
    }
}


JWriter wrapWritter(Writer writer) {
    object jWriter extends JWriterAdapter() {
        
        StringBuilder lineBuffer = StringBuilder();
        
        //TODO thread safe
        shared actual void writeCBuff(CharArray cbuf, JInteger off, JInteger len) {
            for (i in Range<Integer>(off.intValue(), off.intValue() + len.intValue())) {
                value char = cbuf.get(i).string;
                lineBuffer.append(char);
                if (char.equals("\n")) {
                    writer.write(lineBuffer.string);
                    lineBuffer.reset();
                }
            }
        }

        shared actual void close() {
            //flush();
        }
        
        shared actual void flush() {
            //writer.write(messageBuilder.string);
            //messageBuilder.reset();
        }
    }

    return jWriter;
}
