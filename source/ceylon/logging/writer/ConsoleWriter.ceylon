doc "Write log mesages to console."
by "Matej Lazar"
shared class ConsoleWriter() satisfies Writer {
    
    //StringBuilder lineBuffer = StringBuilder();
    
    shared actual void write(String message) {
        print(message);
        //lineBuffer.append(char);
        //if (char.equals("\n")) {
        //    print(lineBuffer.string);
        //    lineBuffer.reset();
        //}
    }
}