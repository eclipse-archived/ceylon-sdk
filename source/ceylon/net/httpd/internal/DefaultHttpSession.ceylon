import ceylon.net.httpd { HttpSession }
import io.undertow.server.session { UtSession = Session }
import org.xnio { IoFuture }

by "Matej Lazar"
class DefaultHttpSession(UtSession utSession) satisfies HttpSession {

    shared actual String id() {
		return utSession.id;
    }
    
    shared actual Object? item(String key) {
       	IoFuture<Object> attributeFuture = utSession.getAttribute(key.string);
       	return attributeFuture.get();
    }
    
    shared actual void put(String key, Object item) {
		utSession.setAttribute(key, item);
	}
	
    shared actual Integer maxInactiveInterval(Integer? interval) {
		if (exists interval) {
			utSession.maxInactiveInterval = interval;
		}
		return utSession.maxInactiveInterval;
	}
	
    shared actual Integer creationTime() {
		return utSession.creationTime;
	}
	
    shared actual Integer lastAccessedTime() {
		return utSession.lastAccessedTime;
	}
	
	
}
