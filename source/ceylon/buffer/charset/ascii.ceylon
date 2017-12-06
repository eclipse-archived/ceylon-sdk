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
    ByteBuffer,
    CharacterBuffer
}
import ceylon.buffer.codec {
    ErrorStrategy,
    PieceConvert,
    DecodeException,
    strict,
    EncodeException
}

"The ASCII character set, as defined by [its specification]
 (http://tools.ietf.org/html/rfc20)."
by ("Stéphane Épardaud")
shared object ascii satisfies Charset {
    shared actual [String+] aliases = [
        "US-ASCII",
        "ANSI_X3.4-1968",
        "iso-ir-6",
        "ANSI_X3.4-1986",
        "ISO_646.irv:1991",
        "ISO646-US",
        "ASCII",
        "us",
        "IBM367",
        "cp367"
    ];
    
    shared actual Integer averageEncodeSize(Integer inputSize) => inputSize;
    shared actual Integer maximumEncodeSize(Integer inputSize) => inputSize;
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize;
    shared actual Integer maximumDecodeSize(Integer inputSize) => inputSize;
    
    shared actual Integer encodeBid({Character*} sample) {
        return if (sample.every((char) => char.integer <= 127)) then 1 else 0;
    }
    shared actual Integer decodeBid({Byte*} sample) {
        variable Integer printable = 1;
        Integer readable;
        for (byte in sample) {
            value signed = byte.signed;
            if (signed < 0) {
                readable = 0;
                break;
            }
            if (!(#20 <= signed <= #7E)) {
                printable = 0;
            }
        } else {
            readable = 1;
        }
        return readable + printable;
    }
    
    shared actual PieceConvert<Byte,Character> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,Character> {
        ByteBuffer output = ByteBuffer.ofSize(1);
        shared actual {Byte*} more(Character input) {
            output.clear();
            value int = input.integer;
            if (int > 127) {
                if (error == strict) {
                    throw EncodeException("Invalid ASCII byte value: ``input``");
                }
            } else {
                output.put(int.byte);
            }
            output.flip();
            return output;
        }
    };
    
    shared actual PieceConvert<Character,Byte> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Character,Byte> {
        CharacterBuffer output = CharacterBuffer.ofSize(1);
        shared actual {Character*} more(Byte input) {
            output.clear();
            if (input.signed < 0) {
                if (error == strict) {
                    throw DecodeException("Invalid ASCII byte value: ``input``");
                }
            } else {
                output.put(input.signed.character);
            }
            output.flip();
            return output;
        }
    };
}
