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
   This package contains the [[Charset]] codec family. These codecs are used to
   encode Strings of text into various standardised binary representations for
   I/O purposes.
   
   Any [[Character]] can be encoded without error by the unicode charsets
   ([[utf8]] and [[utf16]]). However other charsets are only compatible with a
   limited range of characters ([[ascii]] and [[iso_8859_1]]), and so may throw
   an [[ceylon.buffer.codec::EncodeException]]. All charsets can throw
   [[ceylon.buffer.codec::DecodeException]] when decoding [[Byte]]s into
   [[Character]]s, as the valid binary format for each is strictly defined.
   
   To convert a [[String]] to an ASCII byte [[List]]:
   
       List<Byte> bytes = ascii.encode("Hello, World!");
   
   Now, if you want to decode it back:
   
       String string = ascii.decode(bytes);
       
   Similarly, for a [[ceylon.buffer::ByteBuffer]]:
   
       ByteBuffer bytes = utf8.encodeBuffer("Clear Air Turbulence");
       CharacterBuffer chars = utf8.decodeBuffer(bytes);
   
   If you only know the name of a charset you can get its Charset with:
   
       Charset? charset = charsetsByAlias["UTF-8"];
   """
by ("Stéphane Épardaud", "Alex Szczuczko")
shared package ceylon.buffer.charset;
