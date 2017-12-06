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
   This package contains the infrastructure of the [[Codec]] system.
   
   Those wanting to implement their own codecs should refine one of the four
   codec flavours: [[ByteToByteCodec]], [[ByteToCharacterCodec]],
   [[CharacterToByteCodec]], and [[CharacterToCharacterCodec]].
"""
shared package ceylon.buffer.codec;
