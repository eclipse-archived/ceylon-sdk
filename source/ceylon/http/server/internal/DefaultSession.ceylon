/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.http.server {
    Session
}

import io.undertow.server.session {
    UtSession=Session
}

import java.lang {
    Types {
        nativeString
    }
}

by("Matej Lazar")
class DefaultSession(UtSession utSession) 
        satisfies Session {
    
    id => utSession.id;
    
    get(String key) 
            => utSession.getAttribute(key);
    
    defines(String key)
            => nativeString(key) in utSession.attributeNames;
    
    put(String key, Object item) 
            => utSession.setAttribute(key, item);
    
    remove(String key) 
            => utSession.removeAttribute(key);
    
    creationTime => utSession.creationTime;
    
    lastAccessedTime => utSession.lastAccessedTime;
    
    shared actual Integer? timeout {
        value maxInactiveInterval 
                = utSession.maxInactiveInterval;
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
