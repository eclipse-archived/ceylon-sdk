
shared abstract class Status() of starting | started | stoping | stopped {}

shared object starting extends Status() {
    shared actual String string => "starting";
}

shared object started extends Status() {
    shared actual String string => "started";
}

shared object stoping extends Status() {
    shared actual String string => "stoping";
}

shared object stopped extends Status() {
    shared actual String string => "stopped";
}

