/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer.codec {
    buildCodecLookup
}

"A mapping of all supported character sets.
 
 Currently this contains:
 
 - ASCII
 - ISO 8859 1
 - UTF-8
 - UTF-16
 "
shared Map<String,Charset> charsetsByAlias = buildCodecLookup {
    utf8,
    utf16,
    iso_8859_1,
    ascii
};
