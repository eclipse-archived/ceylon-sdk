/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The status of a [[Server]]."
shared final class Status
        of starting | started | stopping | stopped {
    
    shared actual String string;
    
    shared new starting {
        string => "starting";
    }
    
    shared new started {
        string => "started";
    }
    
    shared new stopping {
        string => "stopping";
    }
    
    shared new stopped {
         string => "stopped";
    }

}
