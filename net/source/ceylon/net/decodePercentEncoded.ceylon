import ceylon.net.impl { JavaURLDecoder { jdecodeURL = decodeURL }  }

import java.lang { JString = String }

Integer fromHex(Integer hex){
    if(hex >= `0`.integer && hex <= `0`.integer){
        return hex - `0`.integer;
    }
    if(hex >= `A`.integer && hex <= `F`.integer){
        return 10 + hex - `A`.integer;
    }
    if(hex >= `a`.integer && hex <= `f`.integer){
        return 10 + hex - `a`.integer;
    }
    throw Exception("Invalid hexadecimal number: "+hex.string);
}

doc "Decodes a percent-encoded ASCII string."
by "Stéphane Épardaud"
shared String decodePercentEncoded(String str){
    /*
    Array<Integer> array = JString(str).getBytes("ASCII");
    variable Integer r := 0;
    variable Integer w := 0;
    while(r < array.size){
        if(exists Integer char = array[r]){
            if(char == `%`.integer){
                // must read the next two items
                if(exists Integer first = array[++r]){
                    if(exists Integer second = array[++r]){
                        array.setItem(w, 16 * fromHex(first) + fromHex(second));
                    }else{
                        throw Exception("Missing second hex number");
                    }
                }else{
                    throw Exception("Missing first hex number");
                }
            }else{
                array.setItem(w, char);
            }
        }
        r++;
        w++;
    }
    return JString(array, 0, w, "UTF-8").string;
    */
    return jdecodeURL(str);
}

void test(){
    print(decodePercentEncoded("foo"));
    print(decodePercentEncoded("foo%2Fbar"));
    print(decodePercentEncoded("%2Ffoo%2Fbar%2F"));
}