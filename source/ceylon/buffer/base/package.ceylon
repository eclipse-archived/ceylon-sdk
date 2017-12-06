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
   This package contains the "base" codecs defined by [RFC 4648][rfc4648].
   These codecs are used to encode binary data into various standardised text
   representations for portability in environments that are not binary-safe.
   
   Since the text output of each of the primary
   [[ceylon.buffer.codec::CharacterToByteCodec]] codecs (labelled `String`) in
   this family are within the range of ASCII characters, they all have a
   variant [[ceylon.buffer.codec::ByteToByteCodec]] codec (labelled `Byte`)
   that outputs the [[ceylon.buffer.charset::ascii]] encoded characters
   directly. This is sometimes desireable for efficiency reasons.
   
   Any [[Byte]] can be encoded without error by all of the codecs in this
   family. However [[ceylon.buffer.codec::DecodeException]] may be thrown when
   decoding [[Character]]s or [[Byte]]s into [[Byte]]s, as the valid text
   format for each codec is strictly defined.
   
   Some of the codecs' text forms append padding characters (typically `=`) to
   prevent ambiguity when concatenated. If you're transporting them discretely
   it is technically safe to remove these padding characters. However, while
   the decode functions of the codecs implemented here accept padding-less
   input, it's not uncommon for other libraries to only accept properly padded
   input. Portability may be affected by removing the padding characters.
   
   To convert some [[Byte]]s into a base64 String:
   
       String string = base64StringStandard.encode({0, 1, 2}*.byte);
   
   Now, if you want to decode it back:
   
       List<Byte> bytes = base64StringStandard.decode(string);
       
   Similarly, for a [[ceylon.buffer::Buffer]]:
   
       CharacterBuffer chars = base64StringUrl.encodeBuffer({3, 2, 1}*.byte);
       ByteBuffer bytes = base64StringUrl.decodeBuffer(chars);
   
   If you only know the name of a `base` you can get its `String` form with
   
       CharacterToByteCodec? codec = baseStringByAlias["base32hex"];
   
   and its `Byte` form with
   
       ByteToByteCodec? codec = baseByteByAlias["base32hex"];
   
   [rfc4648]: http://tools.ietf.org/html/rfc4648
"""
by ("Stéphane Épardaud", "Alex Szczuczko")
shared package ceylon.buffer.base;
