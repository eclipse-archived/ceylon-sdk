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
    CharacterToCharacterCodec,
    ErrorStrategy,
    PieceConvert
}

"A classic simple substitution cipher.
 
 Any character found to be a key in the [[encodeMapping]]/[[decodeMapping]] is
 replaced with its corresponding item. Other characters are passed through
 without modification."
shared class Substitution(encodeMapping)
        satisfies CharacterToCharacterCodec {
    shared Map<Character,Character> encodeMapping;
    shared Map<Character,Character> decodeMapping
            = map { for (e in encodeMapping) e.item->e.key };
    
    shared actual default [String+] aliases = [
        "".join({ "Substitution_" }
                .chain(encodeMapping.keys.sort(increasing))
                .chain({ "_" })
                .chain(decodeMapping.keys.sort(increasing)))
    ];
    
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize;
    shared actual Integer maximumDecodeSize(Integer inputSize) => inputSize;
    shared actual Integer averageEncodeSize(Integer inputSize) => inputSize;
    shared actual Integer maximumEncodeSize(Integer inputSize) => inputSize;
    
    shared actual Integer decodeBid({Character*} sample) {
        return if (sample.every((c) => c in decodeMapping.keys)) then 2 else 1;
    }
    shared actual Integer encodeBid({Character*} sample) {
        return if (sample.every((c) => c in encodeMapping.keys)) then 2 else 1;
    }
    
    shared actual PieceConvert<Character,Character> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Character,Character> {
                shared actual {Character*} more(Character input)
                        => if (exists repl = decodeMapping[input]) then { repl } else { input };
            };
    
    shared actual PieceConvert<Character,Character> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<Character,Character> {
                shared actual {Character*} more(Character input)
                        => if (exists repl = encodeMapping[input]) then { repl } else { input };
            };
}
