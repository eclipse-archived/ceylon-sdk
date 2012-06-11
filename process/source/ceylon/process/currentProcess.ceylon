import ceylon.file { current, Path }

shared object currentProcess satisfies Process {
    
    shared actual Iterable<String> commands = {};

    shared actual Destination errorDestination { 
        return inheritDestination; 
    }

    shared actual Integer? exitCode { 
        return null; 
    }

    shared actual Source inputSource { 
        return inheritSource; 
    }

    shared actual void kill() {
        process.exit(1);
    }

    shared actual Destination outputDestination { 
        return inheritDestination; 
    }

    shared actual Path path { 
        return current; 
    }

    shared actual Boolean terminated { 
        return false; 
    }

    shared actual Integer? waitForExit() {
        throw;
    }

}