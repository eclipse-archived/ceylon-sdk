import ceylon.collection { MutableList }

doc "Add log mesages to the list."
by "Matej Lazar"
shared class ListWriter(MutableList<String> list) satisfies Writer {

    //StringBuilder lineBuffer = StringBuilder();
    
    shared actual void write(String message) {
        list.add(message);
        //lineBuffer.append(char);
        //if (char.equals("\n")) {
        //    print("ListWriter: " + lineBuffer.string);
        //    list.add(lineBuffer.string);
        //    lineBuffer.reset();
        //}
    }

}