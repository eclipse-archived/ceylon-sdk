/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a URI Authority part (user, password, host and port)"
by("Stéphane Épardaud")
shared class Authority(user = null, password = null, host = null, port = null,
        ipLiteral = false) {

    "The optional user"
    shared String? user;

    "The optional password"
    shared String? password;

    "The optional host"
    shared String? host;

    "True if the host name is an ipLiteral (IPV6 or later) and has to be represented
     surrounded by [] (square brackets)"
    shared Boolean ipLiteral;

    "The optional port number"
    shared Integer? port;

    "Returns true if the authority part is present (if the host is not null)"
    shared Boolean specified {
        return host exists;
    }

    "Returns an externalisable (percent-encoded) representation of this part"
    shared actual String string {
        return toRepresentation(false);
    }

    "Returns a human (non parseable) representation of this part"
    shared String humanRepresentation {
        return toRepresentation(true);
    }

    "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"
    shared String toRepresentation(Boolean human) {
        if(exists String host = host) {
            StringBuilder b = StringBuilder();
            if(exists String user = user) {
                b.append(human then user else percentEncoder.encodeUser(user));
                if(exists String password = password) {
                    b.appendCharacter(':');
                    b.append(human then password else percentEncoder.encodePassword(password));
                }
                b.appendCharacter('@');
            }
            if(ipLiteral) {
                b.append("[");
                b.append(host);
                b.append("]");
            }else{
                b.append(human then host else percentEncoder.encodeRegName(host));
            }
            if(exists Integer port = port) {
                b.appendCharacter(':');
                b.append(port.string);
            }
            return b.string;
        }
        return "";
    }

    "Create a new [[Authority]] based on this [[Authority]], replacing the `user` with the given value"
    shared Authority withUser(String? user)
        => Authority(user, password, host, port, ipLiteral);

    "Create a new [[Authority]] based on this [[Authority]], replacing the `password` with the given value"
    shared Authority withPassword(String? password)
        => Authority(user, password, host, port, ipLiteral);

    "Create a new [[Authority]] based on this [[Authority]], replacing the `host` and `ipLiteral` with the given values"
    shared Authority withHost(String? host, Boolean ipLiteral = false)
        => Authority(user, password, host, port, ipLiteral);

    "Create a new [[Authority]] based on this [[Authority]], replacing the `port` with the given value"
    shared Authority withPort(Integer? port)
        => Authority(user, password, host, port, ipLiteral);

    "Create a new [[Authority]] based on this [[Authority]], replacing the specified values"
    shared Authority with(
                String? user = this.user, String? password = this.password,
                String? host = this.host, Integer? port = this.port,
                Boolean ipLiteral = this.ipLiteral)
        => Authority(user, password, host, port, ipLiteral);

    "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Authority that) {
            if(this === that) {
                return true;
            }
            return eq(user, that.user)
                && eq(password, that.password)
                && eq(host, that.host)
                && eq(port, that.port)
                && ipLiteral == that.ipLiteral;
        }
        return false;
    }

    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + (user?.hash else 0);
        hash = 31*hash + (password?.hash else 0);
        hash = 31*hash + (host?.hash else 0);
        hash = 31*hash + (port?.hash else 0);
        hash = 31*hash + ipLiteral.hash;
        return hash;
    }
}
