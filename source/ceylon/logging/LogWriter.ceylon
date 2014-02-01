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

"Register a new [[log writer function|log]] with the logging
 system. Log messages are directed to all registered 
 [[LogWriter]]s."
shared void addLogWriter(LogWriter log) 
        => logWriters.add(log);

MutableList<LogWriter> logWriters 
        = ArrayList<LogWriter>();
