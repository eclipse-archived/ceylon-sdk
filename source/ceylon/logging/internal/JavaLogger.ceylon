import ceylon.logging { Level, Writer, Logger, levelTrace, levelDebug, levelInfo, levelWarn, levelError, levelFatal }
import org.jboss.logmanager { LogManager = Logger {manager = getLogger}}
import org.jboss.logmanager.handlers { WriterHandler }
import java.lang { CharArray, JInteger = Integer }
import java.io {JWriter = Writer}
import java.util.logging {
    JLevel = Level, SimpleFormatter/* {
        jOFF = \iOFF,
        jSEVERE = \iSEVERE,
        jWARNING = \iWARNING,
        jINFO = \iINFO,
        jCONFIG = \iCONFIG,
        jFINE = \iFINE,
        jFINER = \iFINER,
        jFINEST = \iFINEST,
        jALL = \iALL
    }*/
}
import ceylon.logging.internal { JLevelAdapter }

by "Matej Lazar"
shared class JavaLogger(String name, Level level, Writer writer) extends Logger(name, level, writer) {

    LogManager logManager = manager(name);

    logManager.setLevelName(level.string.uppercased);
    logManager.level = translateLevel(level);
    
    WriterHandler handler = WriterHandler();
    handler.setWriter(wrapWritter(writer));
    //TODO ceylon formater
    handler.setFormatter(SimpleFormatter());
    logManager.addHandler(handler);

    shared actual void log(Level level, String message) {
        if (this.level <= level ) {
            writer.write(message);
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
        
        StringBuilder messageBuilder = StringBuilder();
        
        shared actual void writeCBuff(CharArray cbuf, JInteger off, JInteger len) {
            for (i in Range<Integer>(off.intValue(), off.intValue() + len.intValue())) {
                messageBuilder.append(cbuf.get(i).string);
            }
        }

        shared actual void close() {
            flush();
        }
        
        shared actual void flush() {
            writer.write(messageBuilder.string);
        }
    }

    return jWriter;
}
