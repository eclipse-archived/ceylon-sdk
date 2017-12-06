/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"This module allows you to read and write to streams, such 
 as files, sockets and pipes.
 
 See the `ceylon.io` package for usage examples."
by("Stéphane Épardaud")
license("Apache Software License")
native("jvm")
module ceylon.io maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import ceylon.buffer "1.3.4-SNAPSHOT";
    shared import ceylon.file "1.3.4-SNAPSHOT";
    import ceylon.collection "1.3.4-SNAPSHOT";
    import java.base "7";
    import java.tls "7";
}
