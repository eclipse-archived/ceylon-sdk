/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer {
    Buffer,
    ByteBuffer,
    CharacterBuffer
}
import ceylon.buffer.codec {
    IncrementalCodec,
    ByteToByteCodec,
    CharacterToByteCodec,
    ErrorStrategy,
    PieceConvert,
    strict,
    ignore,
    DecodeException,
    reset
}

"ceylon.math is JVM only..."
Integer ceiling(Integer x, Float y) {
    value xf = x.float;
    return ((xf + y - 1) / y).integer;
}

"The ASCII value of encoded Character or Byte is easily computable, so it makes
 a nice common hash code. Construct a table of a size that fits the minimal
 window from zero to the max ASCII value of the encode table elements.
 
 If the user provides an index that doesn't match anything in the encode table,
 they will either get null (out of range) or 255 returned to them (in range but
 not in the encode table).
 
 If the given ASCII value does correspond to an element of the encode table,
 then they will get the index of the element in the encode table. Thus, the
 encode table is efficently reversed."
Byte[] toDecodeTable<ToSingle>(
    {ToSingle*} encodeTable,
    Integer(ToSingle) decodeToIndex,
    Byte(Byte) fiddle = (Byte b) => b,
    {ToSingle+}(ToSingle) split = (ToSingle e) => { e }) {
    value ascii_map = map {
        for (i->e in encodeTable.indexed)
            for (s in split(e))
                decodeToIndex(s) -> fiddle(i.byte)
    };
    assert (exists max_ascii = max(ascii_map.keys));
    return [
        for (i in 0..max_ascii)
            if (exists encodeTableIndex = ascii_map[i]) then encodeTableIndex else 255.byte
    ];
}

shared sealed abstract class Base16<ToMutable, ToImmutable, ToSingle>()
        satisfies IncrementalCodec<ToMutable,ToImmutable,ToSingle,ByteBuffer,List<Byte>,Byte>
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given ToSingle satisfies Object {
    
    shared actual Integer averageDecodeSize(Integer inputSize) => ceiling(inputSize, 2.0);
    shared actual Integer maximumDecodeSize(Integer inputSize) => ceiling(inputSize, 2.0);
    shared actual Integer averageEncodeSize(Integer inputSize) => inputSize * 2;
    shared actual Integer maximumEncodeSize(Integer inputSize) => inputSize * 2;
    
    shared formal ToSingle[][] encodeTable;
    shared actual PieceConvert<ToSingle,Byte> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<ToSingle,Byte> {
                shared actual {ToSingle*} more(Byte input) {
                    value r = encodeTable[input.unsigned];
                    "Base16 encode table is invalid. Internal error."
                    assert (exists r);
                    return r;
                }
            };
    
    shared formal Integer decodeToIndex(ToSingle input);
    "The decode table with a precomputed bitwise shift"
    shared formal Byte[] decodeTableLeft;
    "The plain decode table"
    shared formal Byte[] decodeTableRight;
    shared actual PieceConvert<Byte,ToSingle> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,ToSingle> {
                variable Byte? leftwardNibble = null;
                
                shared actual {Byte*} more(ToSingle input) {
                    if (exists left = leftwardNibble) {
                        value right = decodeTableRight[decodeToIndex(input)];
                        if (exists right, right != 255.byte) {
                            leftwardNibble = null;
                            return { left.or(right) };
                        }
                    } else {
                        value left = decodeTableLeft[decodeToIndex(input)];
                        if (exists left, left != 255.byte) {
                            leftwardNibble = left;
                            return empty;
                        }
                    }
                    switch (error)
                    case (strict) {
                        throw DecodeException {
                            "Input element ``input`` is not valid ASCII hex";
                        };
                    }
                    case (ignore) {
                    }
                    case (reset) {
                        leftwardNibble = null;
                    }
                    return empty;
                }
                
                shared actual {Byte*} done() {
                    {Byte*} ret;
                    if (exists left = leftwardNibble) {
                        ret = { left };
                    } else {
                        ret = empty;
                    }
                    leftwardNibble = null;
                    return ret;
                }
            };
}

{Character+} hexDigits = ('0'..'9').chain('a'..'f');
Character[][] base16StringEncodeTable = {
    for (a in hexDigits)
        for (b in hexDigits) { a, b }.sequence()
}.sequence();
shared abstract class Base16String()
        extends Base16<CharacterBuffer,String,Character>()
        satisfies CharacterToByteCodec {
    shared actual Character[][] encodeTable = base16StringEncodeTable;
    
    shared actual Integer decodeToIndex(Character input) => input.integer;
    shared actual Byte[] decodeTableLeft
            = toDecodeTable {
                encodeTable = hexDigits;
                decodeToIndex = decodeToIndex;
                fiddle = (b) => b.leftLogicalShift(4);
                split = (Character s) => { s, s.uppercased };
            };
    shared actual Byte[] decodeTableRight
            = toDecodeTable {
                encodeTable = hexDigits;
                decodeToIndex = decodeToIndex;
                split = (Character s) => { s, s.uppercased };
            };
    
    shared actual Integer decodeBid({Character*} sample) {
        if (sample.every((s) => s in hexDigits)) {
            return 10;
        } else {
            return 0;
        }
    }
}

{Byte+} hexDigitsByte = hexDigits*.integer*.byte;
Byte[][] base16ByteEncodeTable = {
    for (a in hexDigitsByte)
        for (b in hexDigitsByte) { a, b }.sequence()
}.sequence();
shared abstract class Base16Byte()
        extends Base16<ByteBuffer,List<Byte>,Byte>()
        satisfies ByteToByteCodec {
    shared actual Byte[][] encodeTable = base16ByteEncodeTable;
    
    shared actual Integer decodeToIndex(Byte input) => input.unsigned;
    shared actual Byte[] decodeTableLeft
            = toDecodeTable {
                encodeTable = hexDigitsByte;
                decodeToIndex = decodeToIndex;
                fiddle = (b) => b.leftLogicalShift(4);
                split = (Byte s) => { s, s.unsigned.character.uppercased.integer.byte };
            };
    shared actual Byte[] decodeTableRight
            = toDecodeTable {
                encodeTable = hexDigitsByte;
                decodeToIndex = decodeToIndex;
                split = (Byte s) => { s, s.unsigned.character.uppercased.integer.byte };
            };
    
    shared actual Integer decodeBid({Byte*} sample) {
        if (sample.every((s) => s in hexDigitsByte)) {
            return 10;
        } else {
            return 0;
        }
    }
}

shared object base16String extends Base16String() {
    shared actual [String+] aliases = ["base16", "base-16", "base_16"];
    shared actual Integer encodeBid({Byte*} sample) => 5;
}

shared object base16Byte extends Base16Byte() {
    shared actual [String+] aliases = ["base16", "base-16", "base_16"];
    shared actual Integer encodeBid({Byte*} sample) => 5;
}
