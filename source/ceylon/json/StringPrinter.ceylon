"A JSON Printer that prints to a [[String]]."
by("Stéphane Épardaud")
shared class StringPrinter(Boolean pretty = false) 
        extends Printer(pretty){
    
    value builder = StringBuilder();

    "Appends the given value to our `String` representation"
    shared actual void print(String string)
            => builder.append(string);

    "Returns the printed JSON"
    shared actual default String string => builder.string;
}