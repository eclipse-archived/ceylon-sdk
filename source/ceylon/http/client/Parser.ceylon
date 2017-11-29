/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    LinkedList,
    HashMap,
    MutableMap
}
import ceylon.io {
    FileDescriptor
}
import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.charset {
    ascii
}
import ceylon.io.readers {
    FileDescriptorReader
}
import ceylon.http.common {
    Header
}

"Parses an HTTP message from the given [[FileDescriptor]]."
by("Stéphane Épardaud")
shared class Parser(FileDescriptor socket) {
    
    variable Integer byte = 0;
    value buffer = ByteBuffer.ofSize(1024);
    value reader = FileDescriptorReader(socket);
    value charset = ascii;
    
    variable Integer? status = null;
    variable String? reason = null;
    variable Integer? major = null;
    variable Integer? minor = null;
    
    "[[List]] of headers parsed."
    shared LinkedList<Header> headers = LinkedList<Header>();
    
    "[[Map]] of headers parsed, by *lowercased* name."
    shared MutableMap<String,Header> headersByName 
            = HashMap<String,Header>();
    
    //
    // Tests the current byte
    
    Boolean isText() {
        // TEXT: 0-255 (Latin1 char) except CTLs
        return byte <= 255 && !isCtl();
    }
    
    Boolean isChar() {
        // CHAR: 0-127 (ASCII char)
        return byte <= 127;
    }
    
    Boolean isCtl() {
        // CTL: 0-31 and 127 (DEL)
        return byte <= 31 || byte == 127;
    }
    
    Boolean isDigit() {
        // DIGIT: 0-9
        return byte >= '0'.integer && byte <= '9'.integer;
    }
    
    Boolean isHexDigit() {
        // HEX DIGIT: 0-9 or a-f or A-F
        return byte >= '0'.integer && byte <= '9'.integer
         || byte >= 'a'.integer && byte <= 'f'.integer
         || byte >= 'A'.integer && byte <= 'F'.integer;
    }
    
    Boolean isToken() {
        // token: CHAR except CTLs or separators
        return isChar() && !isCtl() && !isSeparator();
    }

    Boolean isSeparator() {
        // separators = "(" | ")" | "<" | ">" | "@"
        //            | "," | ";" | ":" | "\" | <">
        //            | "/" | "[" | "]" | "?" | "="
        //            | "{" | "}" | SP | HT
        return byte == '('.integer || byte == ')'.integer
            || byte == '<'.integer || byte == '>'.integer
            || byte == '@'.integer || byte == ','.integer
            || byte == ';'.integer || byte == ':'.integer
            || byte == '\\'.integer || byte == '"'.integer
            || byte == '/'.integer || byte == '['.integer
            || byte == ']'.integer || byte == '?'.integer
            || byte == '='.integer || byte == '{'.integer
            || byte == '}'.integer || byte == ' '.integer
            || byte == '\t'.integer
        ;
    }

    "Reads a byte"
    throws(`class Exception`, "On end of file")
    void readByte() {
        if (exists b = reader.readByte()) {
            byte = b.signed;
        }
        else {
            throw Exception("Premature EOF");
        }
    }
    
    "Reads a byte and pushes it on the buffer"
    throws(`class Exception`, "On end of file")
    void saveByte() {
        readByte();
        pushByte();
    }
    
    "Pushes the last byte read on to the buffer"
    void pushByte() {
        // grow the line buffer if required
        if(!buffer.hasAvailable) {
            buffer.resize(buffer.capacity + 1024, true);
        }
        // save the byte
        buffer.put(byte.byte);
    }

    "Gets the contents of the buffer as ASCII"
    String getString() {
        buffer.flip();
        return charset.decode(buffer);
    }
    
    "Throws an exception about an unexpected input read"
    throws(`class Exception`, "All the time")
    Exception unexpected(String expected) {
        // try to read some context for an error
        ByteBuffer buffer = ByteBuffer.ofSize(40);
        buffer.put(byte.byte);
        socket.read(buffer);
        buffer.flip();
        String line = ascii.decode(buffer);
        throw Exception("Got byte `` byte `` while expecting `` 
            expected `` (while looking at '`` line ``')");
    }

    "Reads a byte and checks that it's a given ASCII 
     character"
    throws(`class Exception`, 
        "If the byte read is not equal to the given ASCII 
         character")
    void readChar(Character c) {
        readByte();
        atChar(c);
    }

    "Throws if the current byte is not equal to the given 
     ASCII character"
    throws(`class Exception`, 
        "If the current byte is not equal to the given ASCII 
         character")
    void atChar(Character c) {
        if(byte != c.integer) {
            throw unexpected(c.string);
        }
    }

    "Reads as many bytes as in the given ASCII string."
    throws(`class Exception`, 
        "If the bytes read do not match the given ASCII 
         string.")
    void readString(String string) {
        for(c in string) {
            readChar(c);
        }
    }
    
    "Reads a space."
    throws(`class Exception`, 
        "If the byte read is not a space")
    void readSpace() {
        readChar(' ');
    }
    
    "Reads a byte and checks that it's an ASCII digit. 
     Returns the digit read."
    throws(`class Exception`, 
        "If the byte read is not a digit")
    Integer parseDigit() {
        readByte();
        if(!isDigit()) {
            throw unexpected("digit");
        }
        return byte - '0'.integer;
    }

    /*"Reads a byte and checks that it's an ASCII hex digit. 
      Returns the digit read."
    throws(`class Exception`, 
        "If the byte read is not a hex digit.")
    Integer parseHexDigit() {
        readByte();
        return atHexDigit();
    }*/
    
    "Checks that the current byte is an ASCII hex digit. 
     Returns the digit."
    throws(`class Exception`, 
        "If the current byte is not a hex digit.")
    Integer atHexDigit() {
        if(!isHexDigit()) {
            throw unexpected("hex digit");
        }
        if(isDigit()) {
            return byte - '0'.integer;
        }else if(byte >= 'a'.integer && byte <= 'f'.integer) {
            return 10 + byte - 'a'.integer;
        }else if(byte >= 'A'.integer && byte <= 'F'.integer) {
            return 10 + byte - 'A'.integer;
        }else{
            // can't happen
            throw;
        }
    }
    
    "Reads an HTTP version part"
    void parseHttpVersion() {
        readString("HTTP/");
        major = parseDigit();
        readChar('.');
        minor = parseDigit();
    }
    
    "Reads a token plus one byte. Expects the current byte 
     to be the start of token."
    throws(`class Exception`, 
        "If the current byte is not a token byte")
    String atTokenPlusOne() {
        buffer.clear();
        while(isToken()) {
            pushByte();
            readByte();
        }
        value ret = getString();
        if(!ret.empty) {
            return ret;
        }
        throw unexpected("token");
    }
    
    "Reads a CR LF pair. Expects the current byte to be on 
     the CR."
    throws(`class Exception`, 
        "If the current byte is not a CR and if the next is 
         not a LF.")
    void atCrLf() {
        if(byte != '\r'.integer) {
            throw unexpected("\\r");
        }
        readChar('\n');
    }
    
    "Reads a LWS (CR LF (SP|HT)+). Expects the current byte 
     to be on the CR."
    throws(`class Exception`, 
        "If the current byte is not at the start of a LWS.")
    void atLws() {
        atCrLf();
        readByte();
        if(byte != ' '.integer && byte != '\t'.integer) {
            throw unexpected("SP or HT");
        }
        // FIXME: should we eat the rest?
    }
    
    "Reads a quoted string. Expects the current byte to be 
     on the \" symbol"
    throws(`class Exception`, 
        "If the current byte does not start a valid quoted 
         string.")
    void atQuotedText() {
        atChar('"');
        readByte();
        buffer.clear();
        while(byte != '"'.integer) {
            if(byte == '\\'.integer) {
                saveByte();
                if(!isChar()) {
                    throw unexpected("CHAR");
                }
            }else if(byte == '\r'.integer) {
                atLws();
                byte = ' '.integer;
                saveByte();
            }else if(isText()) {
                pushByte();
            }else{
                throw unexpected("TEXT");
            }
            readByte();
        }
        atChar('"');
        String txt = getString();
        print("Quoted text: `` txt ``");
    }
    
    "Parses a status line: 
     HttpVersion StatusCode Reason? CRLF."
    throws(`class Exception`, 
        "If the status line is invalid.")
    void parseStatusLine() {
        parseHttpVersion();
        readSpace();
        status = parseDigit() * 100 + parseDigit() * 10 + parseDigit();
        readSpace();
        buffer.clear();
        saveByte();
        while(isText() && byte != '\r'.integer && byte != '\n'.integer) {
            saveByte();
        }
        buffer.position = buffer.position - 1;
        reason = getString();
        atCrLf();
    }

    "Parses a header line plus one extra byte. Expects the 
     current byte to be on the first character of the header 
     name token."
    throws(`class Exception`, 
        "If the header line is invalid.")
    void atHeaderPlusOne() {
        String name = atTokenPlusOne();
        atChar(':');
        buffer.clear();
        // eat until EOL
        while(true) {
            readByte();
            while(isText()) {
                pushByte();
                readByte();
            }
            atCrLf();
            // go again if we have a SP or HT
            readByte();
            if(byte != ' '.integer && byte != '\t'.integer) {
                break;
            }
        }
        // we must have eaten a CRLF+1
        // FIXME: trimmed?
        String contents = getString().trimmed;
        value header = headersByName[name.lowercased];
        if(exists header) {
            header.values.add(contents);
        }else{
            value newHeader = Header(name, contents);
            headers.add(newHeader);
            headersByName[name.lowercased] = newHeader;
        }
    }
    
    "Parses a chunk header, starting with a CRLF if 
     `firstChunk` is false. Returns the next chunk's size."
    throws(`class Exception`, 
        "If the chunk header could not be parsed.")
    shared Integer parseChunkHeader(Boolean firstChunk) {
        // if it's not the first chunk we must have an 
        // end of chunk marker
        if(!firstChunk) {
            readByte();
            atCrLf();
        }
        // size first
        readByte();
        variable Integer size = atHexDigit();
        readByte();
        while(isHexDigit()) {
            value digit = atHexDigit();
            size = 16 * size + digit;
            readByte();
        }
        // optional extensions
        while(byte == ';'.integer) {
            // eat extension
            atTokenPlusOne();
            if(byte == '='.integer) {
                // we have a value
                readByte();
                if(isToken()) {
                    atTokenPlusOne();
                }else{
                    // must be a quoted string
                    atQuotedText();
                    // that one stops at the last '"'
                    readByte();
                }
            }
        }
        // done with extensions
        atCrLf();
        return size;
    }
    
    "Parses a chunk trailer: optional headers."
    throws(`class Exception`, 
        "If an invalid header is present.")
    shared void parseChunkTrailer() {
        // we may be at CRLF or defining new headers
        parseHeaders();
    }
    
    "Parses a list of headers until a CRLF CRLF sequence"
    throws(`class Exception`, 
        "On invalid headers or EOF")
    shared void parseHeaders() {
        readByte();
        while(true) {
            if(isToken()) {
                atHeaderPlusOne();
            }else if(byte == '\r'.integer) {
                // final line?
                atCrLf();
                break;
            }else{
                throw unexpected("Header line or end of headers");
            }
        }
    }
    
    "Parses an HTTP Response until the end of headers."
    throws(`class Exception`, 
        "On an invalid HTTP Response or EOF")
    shared Response parseResponse() {
        // all the headers are defined in ASCII
        parseStatusLine();
        parseHeaders();
        if(exists status = status) {
            if(exists major = major) {
                if(exists minor = minor) {
                    if(exists reason = reason) {
                        return Response(status, reason, 
                            major, minor, socket, this);
                    }
                }
            }
        }
        throw Exception("Can't happen");
    }
}
