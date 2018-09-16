/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    MutableList,
    ArrayList
}

"A function capable of outputting log messages. `LogWriter`s
 are registered with the logging system by calling 
 [[addLogWriter]]."
see (`function addLogWriter`)
shared alias LogWriter 
        => Anything(Priority, Category, String, Throwable?);

"Register a new [[log writer function|log]] with the logging
 system. Log messages are directed to all registered 
 [[LogWriter]]s."
shared void addLogWriter(LogWriter log) 
        => logWriters.add(log);

MutableList<LogWriter> logWriters 
        = ArrayList<LogWriter>();

"A trivial [[log writer function|LogWriter]] that prints
 messages with priority:
 
 - [[info]] or lower to [[standard out|process.write]], and 
 - [[warn]] or higher to [[standard error|process.writeError]].
 
 The format of the message is:
 
 `[milliseconds] PRIORITY message`
 
 This log writer function must be registered explicitly by
 calling:
 
     addLogWriter(writeSimpleLog);"
shared void writeSimpleLog(
    Priority priority, Category category, 
    String message, Throwable? throwable) {
    value print 
            = priority <= Priority.info 
            then process.write
            else process.writeError;
    print("[``system.milliseconds``] ``priority.string`` ``message``");
    print(operatingSystem.newline);
    if (exists throwable) {
        printStackTrace(throwable, print);
    }
}