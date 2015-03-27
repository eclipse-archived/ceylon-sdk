import ceylon.language.meta.model {
    ClassOrInterface
}
import ceylon.collection {
    MutableMap,
    HashMap
}

"`LoggerFactory` can be satisfied to define a custom
 logging strategy. Typically, an instance of `LoggerFactory`
 will be be assigned to [[loggerFactory]]."
shared
interface LoggerFactory {

    "Function to obtain a [[Logger]] for the given
     [[Category]].

     Callers intending to wrap the returned logger should
     provide the [[ClassOrInterface]] of the wrapper.
     For example:

            FormattingLogger formattingLogger(Category category)
                =>  FormattingLogger(loggerFactory.logger(
                        category, `FormattingLogger`));"
    shared formal
    Logger logger<Wrapper>(
            Category category,
            "The class that will be used to wrap the returned
             value, if any. This may be used by loggers that
             log source file and line number information."
            ClassOrInterface<Wrapper>? wrapper=null)
            given Wrapper satisfies Object;
}

"The factory used by [[logger]] to create or
 obtain [[Logger]]s.

 Assigning a new `LoggerFactory` to `loggerFactory`
 allows the program to specify a custom logging strategy."
shared variable
LoggerFactory loggerFactory = object
        satisfies LoggerFactory {

    MutableMap<String,Logger> loggers = HashMap<String,Logger>();

    class LoggerImpl(shared actual Category category)
            satisfies Logger {

        variable
        Priority? explicitPriority = null;

        shared actual
        Priority priority {
            return explicitPriority else defaultPriority;
        }

        assign priority {
            explicitPriority = priority;
        }

        shared actual
        void log(Priority priority,
                Message message,
                Throwable? throwable) {
            if (enabled(priority)) {
                for (writeLog in logWriters) {
                    writeLog(priority, category,
                            render(message),
                            throwable);
                }
            }
        }
    }

    shared actual
    Logger logger<Wrapper>(
            Category category,
            ClassOrInterface<Wrapper>? warpper)
            given Wrapper satisfies Object {

        if (exists logger = loggers[category.name]) {
            return logger;
        }
        else {
            value logger = LoggerImpl(category);
            loggers.put(category.name, logger);
            return logger;
        }
    }
};
