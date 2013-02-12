doc "An object representing a session between a server and a client."
by "Matej Lazar"
shared interface HttpSession {
    
    doc "Session unique id."
    shared formal String id();
    
    doc "Returns an object from users session defined by given key."
    shared formal Object? item(String key);
    
    doc "Store an object to users session. Object is identified by given key."
    shared formal void put(String key, Object item);
    
    doc "Specifies the time, in seconds, between client requests before the server will invalidate this session.
         A negative time indicates the session should never timeout."
    shared formal Integer maxInactiveInterval(Integer? interval = null);
    
    doc "Returns the time when this session was created, measured in milliseconds since midnight January 1, 1970 GMT."
    shared formal Integer creationTime();
    
    doc "Returns the last time the client sent a request associated with this session, 
         as the number of milliseconds since midnight January 1, 1970 GMT, 
         and marked by the time the container received the request."
    shared formal Integer lastAccessedTime();
}