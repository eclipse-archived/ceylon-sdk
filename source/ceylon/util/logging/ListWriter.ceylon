import ceylon.util.logging { LogWriter }
import ceylon.collection { MutableList }

doc "Add log mesages to list."
by "Matej Lazar"
shared class ListWriter(MutableList<String> list) satisfies LogWriter {
    shared actual void write(String mesasge) {
        list.add(mesasge);
    }
}