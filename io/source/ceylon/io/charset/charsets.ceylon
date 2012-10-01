doc "The list of all supported character sets.
     
     Currently this lists consists of:
     
     - ASCII
     - ISO 8859 1
     - UTF-8
     - UTF-16
     "
by "Stéphane Épardaud"
shared Charset[] charsets = { ascii, iso_8859_1, utf8, utf16 };

doc "Gets a character set by name or alias."
by "Stéphane Épardaud"
see (charsets)
shared Charset? getCharset(String name){
    value lc = name.lowercased;
    for(charset in charsets){
        if(charset.name.lowercased == lc){
            return charset;
        }
        for(aliasName in charset.aliases){
            if(aliasName.lowercased == lc){
                return charset;
            }
        }
    }
    return null;
}