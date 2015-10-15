"The importance of a log message. `Priority`s have a total
 order running from most important to least important."
shared abstract class Priority(string, integer)
        of fatal|error|warn|info|debug|trace 
        satisfies Comparable<Priority> {
    "The name of this priority."
    shared actual String string;
    "An integer measuring the importance of this `Priority`."
    Integer integer;
    compare(Priority other) => integer<=>other.integer;
}

"A serious failure, usually leading to program termination."
shared object fatal extends Priority("FATAL",100) {}

"An error, often causing the program to abandon its current 
 work."
shared object error extends Priority("ERROR",90) {}

"A warning, usually indicating that the program can continue
 with its current work."
shared object warn extends Priority("WARN",80) {}

"An important event in the program lifecycle."
shared object info extends Priority("INFO",70) {}

"An event that is only interesting when debugging the 
 program."
shared object debug extends Priority("DEBUG",60) {}

"An event that is only interesting when the programmer is
 pulling out hair while debugging the program."
shared object trace extends Priority("TRACE",50) {}

"The default [[Priority]] for newly created [[Logger]]s. 
 This priority is inherited by all other loggers which do 
 not have a priority explicitly assigned to 
 [[Logger.priority]]."
shared variable Priority defaultPriority = package.info;
