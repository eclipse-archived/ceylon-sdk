/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""This module defines APIs common to HTTP clients and servers.
"""

by("Stéphane Épardaud", "Matej Lazar")
license("Apache Software License")
native("jvm")
module ceylon.http.common maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import ceylon.collection "1.3.4-SNAPSHOT";
    shared import ceylon.io "1.3.4-SNAPSHOT";
}
