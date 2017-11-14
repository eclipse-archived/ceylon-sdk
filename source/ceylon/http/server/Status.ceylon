/********************************************************************************
 * Copyright (c) {date} Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The status of a [[Server]]."
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

