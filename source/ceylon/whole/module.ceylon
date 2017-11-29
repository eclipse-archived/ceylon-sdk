/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"This module provides an arbitrary-precision integer numeric type.

 The type [[Whole|ceylon.whole::Whole]] is a first-class numeric type and
 support all the usual mathematical operations:

     Whole i = wholeNumber(12P);
     Whole j = wholeNumber(3);
     Whole n = i**j + j;
     print(n); //prints 1728000000000000000000000000000000000003"
by("Tom Bentley", "John Vasileff")
module ceylon.whole maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    native("jvm") import java.base "7";
}
