/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The importance of a log message. `Priority`s have a total
 order running from most important to least important."
shared final class Priority
        of fatal | error | warn | info | debug | trace 
        satisfies Comparable<Priority> {
    
    "The name of this priority."
    shared actual String string;
    
    "An integer measuring the importance of this `Priority`."
    Integer integer;
    
    abstract new with(String string, Integer integer) {
        this.string = string;
        this.integer = integer;
    }

    "A serious failure, usually leading to program termination."
    shared new fatal extends with("FATAL",100) {}
    
    "An error, often causing the program to abandon its current 
     work."
    shared new error extends with("ERROR",90) {}
    
    "A warning, usually indicating that the program can continue
     with its current work."
    shared new warn extends with("WARN",80) {}
    
    "An important event in the program lifecycle."
    shared new info extends with("INFO",70) {}
    
    "An event that is only interesting when debugging the 
     program."
    shared new debug extends with("DEBUG",60) {}
    
    "An event that is only interesting when the programmer is
     pulling out hair while debugging the program."
    shared new trace extends with("TRACE",50) {}
    
    compare(Priority other) => integer<=>other.integer;
}

"A serious failure, usually leading to program termination."
deprecated("Use [[Priority.fatal]]")
shared Priority fatal => Priority.fatal;

"An error, often causing the program to abandon its current 
 work."
deprecated("Use [[Priority.error]]")
shared Priority error => Priority.error;

"A warning, usually indicating that the program can continue
 with its current work."
deprecated("Use [[Priority.warn]]")
shared Priority warn => Priority.warn;

"An important event in the program lifecycle."
deprecated("Use [[Priority.info]]")
shared Priority info => Priority.info;

"An event that is only interesting when debugging the 
 program."
deprecated("Use [[Priority.debug]]")
shared Priority debug => Priority.debug;

"An event that is only interesting when the programmer is
 pulling out hair while debugging the program."
deprecated("Use [[Priority.trace]]")
shared Priority trace => Priority.trace;

"The default [[Priority]] for newly created [[Logger]]s. 
 This priority is inherited by all other loggers which do 
 not have a priority explicitly assigned to 
 [[Logger.priority]]."
shared variable Priority defaultPriority = Priority.info;
