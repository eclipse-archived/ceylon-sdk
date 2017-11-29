/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""
   This module allows you to convert between text and binary forms of data.
   
   For efficiency of I/O (see the `ceylon.io` module), [[Buffer]]s are the core
   representation which [[ceylon.buffer.codec::Codec]]s output from the
   encode/decode operations, but it's still easy to get more general types like
   [[Array]]s and [[String]]s. Input to the operations can be any stream type.
   
   [[ceylon.buffer.codec::Codec]]s are symmetrical, as any data that is
   [[encode|ceylon.buffer.codec::StatelessCodec.encode]]d then
   [[decode|ceylon.buffer.codec::StatelessCodec.decode]]d (or vice versa) with
   the same codec will be at least semantically equivalent to the starting
   data, and usually exactly equal.
   
   [[ceylon.buffer.codec::Codec]]s come in four flavours:
   [[ByteToByte|ceylon.buffer.codec::ByteToByteCodec]],
   [[ByteToCharacter|ceylon.buffer.codec::ByteToCharacterCodec]],
   [[CharacterToByte|ceylon.buffer.codec::CharacterToByteCodec]], and
   [[CharacterToCharacter|ceylon.buffer.codec::CharacterToCharacterCodec]]. The
   middle two are similar, yet kept seperate to support differing conventions
   around what `encode` and `decode` mean in particular codec families. To
   enhance efficiency, `ByteToByteCodec`s are offered as variants of some
   `CharacterToByteCodec`s where the `Character` form is comprised of ASCII
   characters only. These variants' output is the same as using the original
   plus encoding the characters with the [[ASCII|ceylon.buffer.charset::ascii]]
   charset.
   
   There are three currently implemented codec families:
   [[charsets|package ceylon.buffer.charset]]
   ([[UTF-8|ceylon.buffer.charset::utf8]] for example),
   [[base encodings|package ceylon.buffer.base]] (like
   [[base64|ceylon.buffer.base::base64ByteStandard]]), and
   [[text ciphers|package ceylon.buffer.text]]
   ([[rot13|ceylon.buffer.text::rot13]] for example). See those packages for
   further documentation and examples of use.
"""
by ("Stéphane Épardaud", "Alex Szczuczko")
module ceylon.buffer maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    import ceylon.collection "1.3.4-SNAPSHOT";
    native ("jvm") import java.base "7";
}
