
shared abstract class HttpdStatus() of httpdStarting | httpdStarted | httpdStoping | httpdStopped {}

shared object httpdStarting extends HttpdStatus() {
    shared actual String string => "httpdStarting";
}

shared object httpdStarted extends HttpdStatus() {
    shared actual String string => "httpdStarted";
}

shared object httpdStoping extends HttpdStatus() {
    shared actual String string => "httpdStoping";
}

shared object httpdStopped extends HttpdStatus() {
    shared actual String string => "httpdStopped";
}

