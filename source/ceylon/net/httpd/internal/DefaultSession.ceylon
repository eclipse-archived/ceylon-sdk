import ceylon.net.httpd { Session }

import io.undertow.server.session { UtSession=Session }

by "Matej Lazar"
class DefaultSession(UtSession utSession) satisfies Session {
    
    shared actual String id => utSession.id;
    
    shared actual Object? get(String key) => 
            utSession.getAttribute(key.string);
    
    shared actual void put(String key, Object item) =>
            utSession.setAttribute(key, item);
    
    shared actual Integer creationTime => utSession.creationTime;
    
    shared actual Integer lastAccessedTime => utSession.lastAccessedTime;
    
    shared actual Integer? timeout {
        value maxInactiveInterval = utSession.maxInactiveInterval;
        return maxInactiveInterval>=0 then maxInactiveInterval;
    }
    assign timeout {
        if (exists timeout) {
            utSession.maxInactiveInterval = timeout;
        }
        else {
            utSession.maxInactiveInterval = -1;
        }
    }
    
}
