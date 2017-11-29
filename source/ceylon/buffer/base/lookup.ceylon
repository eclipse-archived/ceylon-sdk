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
    buildCodecLookup,
    CharacterToByteCodec,
    ByteToByteCodec
}

"A mapping of all supported String base variants.
 
 Currently this contains:
 
 - Base64 Standard
 - Base64 URL Safe
 - Base16
 "
shared Map<String,CharacterToByteCodec> baseStringByAlias = buildCodecLookup {
    base64StringStandard,
    base64StringUrl,
    base16String
};

"A mapping of all supported Byte base variants.
 
 Currently this contains:
 
 - Base64 Standard
 - Base64 URL Safe
 - Base16
 "
shared Map<String,ByteToByteCodec> baseByteByAlias = buildCodecLookup {
    base64ByteStandard,
    base64ByteUrl,
    base16Byte
};
