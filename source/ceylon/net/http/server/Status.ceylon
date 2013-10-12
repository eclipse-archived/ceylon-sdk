
shared abstract class Status() 
        of starting | started | stopping | stopped {}

shared object starting extends Status() {
    shared actual String string => "starting";
}

shared object started extends Status() {
    shared actual String string => "started";
}

shared object stopping extends Status() {
    shared actual String string => "stopping";
}

shared object stopped extends Status() {
    shared actual String string => "stopped";
}

