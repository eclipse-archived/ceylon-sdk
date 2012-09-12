import ceylon.io { FileDescriptor }
import ceylon.io.buffer { newByteBuffer, ByteBuffer }
import ceylon.io.readers { ByteReader, FileDescriptorReader }
import ceylon.io.charset { ascii }
import ceylon.collection { LinkedList, HashMap, MutableMap }

doc "Parses an HTTP message from the given [[FileDescriptor]]."
by "Stéphane Épardaud"
shared class Parser(FileDescriptor socket){
    
    variable Integer byte := 0;
    value buffer = newByteBuffer(1024);
    value reader = ByteReader(FileDescriptorReader(socket));
    value decoder = ascii.newDecoder();
    
    variable Integer? status := null;
    variable String? reason := null;
    variable Integer? major := null;
    variable Integer? minor := null;
    
    doc "[[List]] of headers parsed."
    shared LinkedList<Header> headers = LinkedList<Header>();
    
    doc "[[Map]] of headers parsed, by name."
    shared MutableMap<String,Header> headersByName = HashMap<String,Header>();
    
    //
    // Tests the current byte
    
    Boolean isText(){
        // TEXT: 0-255 (Latin1 char) except CTLs
        return byte <= 255 && !isCtl();
    }
    
    Boolean isChar(){
        // CHAR: 0-127 (ASCII char)
        return byte <= 127;
    }
    
    Boolean isCtl(){
        // CTL: 0-31 and 127 (DEL)
        return byte <= 31 || byte == 127;
    }
    
    Boolean isDigit(){
        // DIGIT: 0-9
        return byte >= `0`.integer && byte <= `9`.integer;
    }
    
    Boolean isHexDigit(){
        // HEX DIGIT: 0-9 or a-f or A-F
        return byte >= `0`.integer && byte <= `9`.integer
         || byte >= `a`.integer && byte <= `f`.integer
         || byte >= `A`.integer && byte <= `F`.integer;
    }
    
    Boolean isToken(){
        // token: CHAR except CTLs or separators
        return isChar() && !isCtl() && !isSeparator();
    }

    Boolean isSeparator(){
        // separators = "(" | ")" | "<" | ">" | "@"
        //            | "," | ";" | ":" | "\" | <">
        //            | "/" | "[" | "]" | "?" | "="
        //            | "{" | "}" | SP | HT
        return byte == `(`.integer || byte == `)`.integer
            || byte == `<`.integer || byte == `>`.integer
            || byte == `@`.integer || byte == `,`.integer
            || byte == `;`.integer || byte == `:`.integer
            || byte == `\\`.integer || byte == `"`.integer
            || byte == `/`.integer || byte == `[`.integer
            || byte == `]`.integer || byte == `?`.integer
            || byte == `=`.integer || byte == `{`.integer
            || byte == `}`.integer || byte == ` `.integer
            || byte == `\t`.integer
        ;
    }

    doc "Reads a byte"
    throws "On end of file"
    void readByte(){
        byte := reader.readByte();
        if(byte < 0){
            throw Exception("Premature EOF");
        }
    }
    
    doc "Reads a byte and pushes it on the buffer"
    throws "On end of file"
    void saveByte(){
        readByte();
        pushByte();
    }
    
    doc "Pushes the last byte read on to the buffer"
    void pushByte(){
        // grow the line buffer if required
        if(!buffer.hasAvailable){
            buffer.resize(buffer.capacity + 1024, true);
        }
        // save the byte
        buffer.put(byte);
    }

    doc "Gets the contents of the buffer as ASCII"
    String? getString(){
        buffer.flip();
        decoder.decode(buffer);
        return decoder.consumeAvailable();
    }
    
    doc "Throws an exception about an unexpected input read"
    throws "All the time"
    Exception unexpected(String expected){
        // try to read some context for an error
        ByteBuffer buffer = newByteBuffer(40);
        buffer.put(byte);
        socket.read(buffer);
        buffer.flip();
        String line = ascii.decode(buffer);
        throw Exception("Got byte " byte " while expecting " expected " (while looking at '" line "')");
    }

    doc "Reads a byte and checks that it's a given ASCII char"
    throws "If if the byte read is not equal to the given ASCII char"
    void readChar(Character c){
        readByte();
        atChar(c);
    }

    doc "Throws if the current byte is not equal to the given ASCII char"
    throws "If if the current byte is not equal to the given ASCII char"
    void atChar(Character c){
        if(byte != c.integer){
            throw unexpected(c.string);
        }
    }

    doc "Reads as many bytes as in the given ASCII string."
    throws "If the bytes read do not match the given ASCII string."
    void readString(String string){
        for(c in string){
            readChar(c);
        }
    }
    
    doc "Reads a space."
    throws "If the byte read is not a space"
    void readSpace(){
        readChar(` `);
    }
    
    doc "Reads a byte and checks that it's an ASCII digit. Returns the digit read."
    throws "If the byte read is not a digit"
    Integer parseDigit(){
        readByte();
        if(!isDigit()){
            throw unexpected("digit");
        }
        return byte - `0`.integer;
    }

    doc "Reads a byte and checks that it's an ASCII hex digit. Returns the digit read."
    throws "If the byte read is not a hex digit."
    Integer parseHexDigit(){
        readByte();
        return atHexDigit();
    }
    
    doc "Checks that the current byte is an ASCII hex digit. Returns the digit."
    throws "If the current byte is not a hex digit."
    Integer atHexDigit(){
        if(!isHexDigit()){
            throw unexpected("hex digit");
        }
        if(isDigit()){
            return byte - `0`.integer;
        }else if(byte >= `a`.integer && byte <= `f`.integer){
            return 10 + byte - `a`.integer;
        }else if(byte >= `A`.integer && byte <= `F`.integer){
            return 10 + byte - `A`.integer;
        }else{
            // can't happen
            throw;
        }
    }
    
    doc "Reads an HTTP version part"
    void parseHttpVersion(){
        readString("HTTP/");
        major := parseDigit();
        readChar(`.`);
        minor := parseDigit();
    }
    
    doc "Reads a token plus one byte. Expects the current byte to be the start of token."
    throws "If the current byte is not a token byte"
    String atTokenPlusOne(){
        buffer.clear();
        while(isToken()){
            pushByte();
            readByte();
        }
        value ret = getString();
        if(exists ret){
            return ret;
        }
        throw unexpected("token");
    }
    
    doc "Reads a CR LF pair. Expects the current byte to be on the CR."
    throws "If the current byte is not a CR and if the next is not a LF."
    void atCrLf(){
        if(byte != `\r`.integer){
            throw unexpected("\\r");
        }
        readChar(`\n`);
    }
    
    doc "Reads a LWS (CR LF (SP|HT)+). Expects the current byte to be on the CR."
    throws "If the current byte is not at the start of a LWS."
    void atLws(){
        atCrLf();
        readByte();
        if(byte != ` `.integer && byte != `\t`.integer){
            throw unexpected("SP or HT");
        }
        // FIXME: should we eat the rest?
    }
    
    doc "Reads a quoted string. Expects the current byte to be on the \" symbol"
    throws "If the current byte does not start a valid quoted string." 
    void atQuotedText(){
        atChar(`"`);
        readByte();
        buffer.clear();
        while(byte != `"`.integer){
            if(byte == `\\`.integer){
                saveByte();
                if(!isChar()){
                    throw unexpected("CHAR");
                }
            }else if(byte == `\r`.integer){
                atLws();
                byte := ` `.integer;
                saveByte();
            }else if(isText()){
                pushByte();
            }else{
                throw unexpected("TEXT");
            }
            readByte();
        }
        atChar(`"`);
        String txt = getString() else "";
        print("Quoted text: " txt "");
    }
    
    doc "Parses a status line: HttpVersion StatusCode Reason? CRLF."
    throws "If the status line is invalid."
    void parseStatusLine(){
        parseHttpVersion();
        readSpace();
        status := parseDigit() * 100 + parseDigit() * 10 + parseDigit();
        readSpace();
        buffer.clear();
        saveByte();
        while(isText() && byte != `\r`.integer && byte != `\n`.integer){
            saveByte();
        }
        buffer.position := buffer.position - 1;
        reason := getString() else "";
        atCrLf();
    }

    doc "Parses a header line plus one extra byte. 
         Expects the current byte to be on the first character of the
         header name token."
    throws "If the header line is invalid."
    void atHeaderPlusOne(){
        String name = atTokenPlusOne();
        atChar(`:`);
        buffer.clear();
        // eat until EOL
        while(true){
            readByte();
            while(isText()){
                pushByte();
                readByte();
            }
            atCrLf();
            // go again if we have a SP or HT
            readByte();
            if(byte != ` `.integer && byte != `\t`.integer){
                break;
            }
        }
        // we must have eaten a CRLF+1
        // FIXME: trimmed?
        String contents = getString()?.trimmed else "";
        value header = headersByName[name.lowercased];
        if(exists header){
            header.values.add(contents);
        }else{
            value newHeader = Header(name, contents);
            headers.add(newHeader);
            headersByName.put(name.lowercased, newHeader);
        }
    }
    
    doc "Parses a chunk header, starting with a CRLF if `firstChunk` is false.
         Returns the next chunk's size."
    throws "If the chunk header could not be parsed."
    shared Integer parseChunkHeader(Boolean firstChunk) {
        // if it's not the first chunk we must have an end of chunk marker
        if(!firstChunk){
            readByte();
            atCrLf();
        }
        // size first
        readByte();
        variable Integer size := atHexDigit();
        readByte();
        while(isHexDigit()){
            value digit = atHexDigit();
            size := 16 * size + digit;
            readByte();
        }
        // optional extensions
        while(byte == `;`.integer){
            // eat extension
            atTokenPlusOne();
            if(byte == `=`.integer){
                // we have a value
                readByte();
                if(isToken()){
                    atTokenPlusOne();
                }else{
                    // must be a quoted string
                    atQuotedText();
                    // that one stops at the last `"`
                    readByte();
                }
            }
        }
        // done with extensions
        atCrLf();
        return size;
    }
    
    doc "Parses a chunk trailer: optional headers."
    throws "If an invalid header is present."
    shared void parseChunkTrailer() {
        // we may be at CRLF or defining new headers
        parseHeaders();
    }
    
    doc "Parses a list of headers until a CRLF CRLF sequence"
    throws "On invalid headers or EOF"
    shared void parseHeaders() {
        readByte();
        while(true){
            if(isToken()){
                atHeaderPlusOne();
            }else if(byte == `\r`.integer){
                // final line?
                atCrLf();
                break;
            }else{
                throw unexpected("Header line or end of headers");
            }
        }
    }
    
    doc "Parses an HTTP Response until the end of headers."
    throws "On an invalid HTTP Response or EOF"
    shared Response parseResponse() {
        // all the headers are defined in ASCII
        parseStatusLine();
        parseHeaders();
        if(exists status = status){
            if(exists major = major){
                if(exists minor = minor){
                    if(exists reason = reason){
                        return Response(status, reason, major, minor, socket, this);
                    }
                }
            }
        }
        throw Exception("Can't happen");
    }
}
