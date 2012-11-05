shared interface HttpSession {

	shared formal String id();

	shared formal Object? item(String key);

	shared formal void put(String key, Object item);

    shared formal Integer maxInactiveInterval(Integer? interval = null);
	
    shared formal Integer creationTime();
	
    shared formal Integer lastAccessedTime();
}