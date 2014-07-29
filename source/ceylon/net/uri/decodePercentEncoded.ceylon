import java.lang { JString = String, ByteArray }

Integer fromHex(Integer hex){
    if(hex >= '0'.integer && hex <= '9'.integer){
        return hex - '0'.integer;
    }
    if(hex >= 'A'.integer && hex <= 'F'.integer){
        return 10 + hex - 'A'.integer;
    }
    if(hex >= 'a'.integer && hex <= 'f'.integer){
        return 10 + hex - 'a'.integer;
    }
    throw Exception("Invalid hexadecimal number: "+hex.string);
}

"Decodes a percent-encoded ASCII string."
by("Stéphane Épardaud")
shared String decodePercentEncoded(String str){
    Byte percent = '%'.integer.byte;
    ByteArray array = JString(str).getBytes("ASCII");
    variable Integer r = 0;
    variable Integer w = 0;
    while(r < array.size){
        Byte char = array.get(r);
        if(char == percent){
            // must read the next two items
            if(++r < array.size){
                Byte first = array.get(r);
                if(++r < array.size){
                    Byte second = array.get(r);
                    array.set(w, (16 * fromHex(first.unsigned) + fromHex(second.unsigned)).byte);
                }else{
                    throw Exception("Missing second hex number");
                }
            }else{
                throw Exception("Missing first hex number");
            }
        }else{
            array.set(w, char);
        }
        r++;
        w++;
    }
    return JString(array, 0, w, "UTF-8").string;
}
