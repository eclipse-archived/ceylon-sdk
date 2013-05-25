import ceylon.collection { MutableList }

doc "Add log mesages to a list."
by "Matej Lazar"
shared class ListWriter(MutableList<String> list) satisfies Writer {
    shared actual void write(String message) {
        list.add(message);
    }
}