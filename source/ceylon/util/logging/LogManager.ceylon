import ceylon.util.logging { Log, LogWriter }
import ceylon.util.logging.internal { DefaultLogManager }

doc "Configure log properties."
by "Matej Lazar"
shared interface LogManager {
    
    shared formal Log loggerInstance(String name);
    
    doc "Define LogWriter. By default ConsoleWriter is used."
    shared formal variable LogWriter logWriter;
}

shared LogManager logManager => DefaultLogManager();