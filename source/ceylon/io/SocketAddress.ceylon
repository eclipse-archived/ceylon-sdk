/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents an Internet socket address, consisting of
 an [[IP address or host name|address]] together with
 a [[TCP port|port]]."
by("Stéphane Épardaud")
shared class SocketAddress(address, port) {
    
    "The host name or IP part of that internet socket 
     address."
    shared String address;

    "The TCP port part of that internet socket address."
    shared Integer port;
}