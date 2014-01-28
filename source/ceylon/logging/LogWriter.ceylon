import ceylon.collection {
    MutableList,
    ArrayList
}

"A function capable of outputting log messages. `LogWriter`s
 are registered with the logging system by calling 
 [[addLogWriter]]."
see (`function addLogWriter`)
shared alias LogWriter 
        => Anything(Priority,Category,String, Exception?);

"Register a new [[LogWriter]] with the logging system. Log
 messages are directed to all registered [[LogWriter]]s."
shared void addLogWriter(LogWriter logWriter) 
        => logWriters.add(logWriter);

MutableList<LogWriter> logWriters = ArrayList<LogWriter>();
