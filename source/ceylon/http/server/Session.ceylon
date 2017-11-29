/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"An object representing a session between a server and a 
 client."
by("Matej Lazar")
shared sealed interface Session 
        satisfies Correspondence<String, Object> {
    
    "Session unique id."
    shared formal String id;
    
    "Returns an object from the user session identified 
     by the given key."
    shared actual formal Object? get(String key);
    
    "Store an object to users session identified by 
     given key."
    shared formal void put(String key, Object item);
    
    "Removes an object from users session identified by
     given key."
    shared formal Object? remove(String key);
    
    "The time, in seconds, between client requests before 
     the server will invalidate this session. A null time 
     indicates the session should never timeout."
    shared formal variable Integer? timeout;
    
    "Returns the time when this session was created, 
     measured in milliseconds since midnight January 1, 
     1970 GMT."
    shared formal Integer creationTime;
    
    "Returns the last time the client sent a request 
     associated with this session, as the number of 
     milliseconds since midnight January 1, 1970 GMT, 
     and marked by the time the container received the 
     request."
    shared formal Integer lastAccessedTime;
}