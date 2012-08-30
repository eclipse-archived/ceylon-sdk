
shared Charset[] charsets = { ascii, iso_8859_1, utf8, utf16 };

shared Charset? getCharset(String name){
    value lc = name.lowercased;
    for(charset in charsets){
        if(charset.name.lowercased == lc){
            return charset;
        }
        for(alias in charset.aliases){
            if(alias.lowercased == lc){
                return charset;
            }
        }
    }
    return null;
}