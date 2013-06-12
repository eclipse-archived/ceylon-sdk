import java.lang { JString = String { format }, JByte = Byte, ByteArray }
import java.util { BitSet }

"Contains methods for percent-encoding. 
     See http://tools.ietf.org/html/rfc3986#appendix-A for specifications."
by("Stéphane Épardaud")
shared object percentEncoder {
    
    /**
     * gen-delims = ":" / "/" / "?" / "#" / "[" / "]" / "@"
     */
    BitSet gen_delims = BitSet();
    
    gen_delims.set(':'.integer);
    gen_delims.set('/'.integer);
    gen_delims.set('?'.integer);
    gen_delims.set('#'.integer);
    gen_delims.set('['.integer);
    gen_delims.set(']'.integer);
    gen_delims.set('@'.integer);

    /**
     * sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
     */
    BitSet sub_delims = BitSet();
    
    sub_delims.set('!'.integer);
    sub_delims.set('$'.integer);
    sub_delims.set('&'.integer);
    sub_delims.set('\''.integer);
    sub_delims.set('('.integer);
    sub_delims.set(')'.integer);
    sub_delims.set('*'.integer);
    sub_delims.set('+'.integer);
    sub_delims.set(','.integer);
    sub_delims.set(';'.integer);
    sub_delims.set('='.integer);

    /**
     * reserved = gen-delims | sub-delims
     */
    BitSet reserved = BitSet();
    
    reserved.or(gen_delims);
    reserved.or(sub_delims);

    /**
     * lowalpha = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" |
     * "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
     */
    BitSet low_alpha = BitSet();
    
    low_alpha.set('a'.integer);
    low_alpha.set('b'.integer);
    low_alpha.set('c'.integer);
    low_alpha.set('d'.integer);
    low_alpha.set('e'.integer);
    low_alpha.set('f'.integer);
    low_alpha.set('g'.integer);
    low_alpha.set('h'.integer);
    low_alpha.set('i'.integer);
    low_alpha.set('j'.integer);
    low_alpha.set('k'.integer);
    low_alpha.set('l'.integer);
    low_alpha.set('m'.integer);
    low_alpha.set('n'.integer);
    low_alpha.set('o'.integer);
    low_alpha.set('p'.integer);
    low_alpha.set('q'.integer);
    low_alpha.set('r'.integer);
    low_alpha.set('s'.integer);
    low_alpha.set('t'.integer);
    low_alpha.set('u'.integer);
    low_alpha.set('v'.integer);
    low_alpha.set('w'.integer);
    low_alpha.set('x'.integer);
    low_alpha.set('y'.integer);
    low_alpha.set('z'.integer);

    /**
     * upalpha = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" |
     * "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
     */
    BitSet up_alpha = BitSet();
    
    up_alpha.set('A'.integer);
    up_alpha.set('B'.integer);
    up_alpha.set('C'.integer);
    up_alpha.set('D'.integer);
    up_alpha.set('E'.integer);
    up_alpha.set('F'.integer);
    up_alpha.set('G'.integer);
    up_alpha.set('H'.integer);
    up_alpha.set('I'.integer);
    up_alpha.set('J'.integer);
    up_alpha.set('K'.integer);
    up_alpha.set('L'.integer);
    up_alpha.set('M'.integer);
    up_alpha.set('N'.integer);
    up_alpha.set('O'.integer);
    up_alpha.set('P'.integer);
    up_alpha.set('Q'.integer);
    up_alpha.set('R'.integer);
    up_alpha.set('S'.integer);
    up_alpha.set('T'.integer);
    up_alpha.set('U'.integer);
    up_alpha.set('V'.integer);
    up_alpha.set('W'.integer);
    up_alpha.set('X'.integer);
    up_alpha.set('Y'.integer);
    up_alpha.set('Z'.integer);

    /**
     * alpha = lowalpha | upalpha
     */
    BitSet alpha = BitSet();
    
    alpha.or(low_alpha);
    alpha.or(up_alpha);

    /**
     * digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
     */
    BitSet digit = BitSet();
    
    digit.set('0'.integer);
    digit.set('1'.integer);
    digit.set('2'.integer);
    digit.set('3'.integer);
    digit.set('4'.integer);
    digit.set('5'.integer);
    digit.set('6'.integer);
    digit.set('7'.integer);
    digit.set('8'.integer);
    digit.set('9'.integer);

    /**
     * alphanum = alpha | digit
     */
    BitSet alphanum = BitSet();
    
    alphanum.or(alpha);
    alphanum.or(digit);

    /**
     * unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
     */
    BitSet unreserved = BitSet();
    
    unreserved.or(alpha);
    unreserved.or(digit);
    unreserved.set('-'.integer);
    unreserved.set('.'.integer);
    unreserved.set('_'.integer);
    unreserved.set('~'.integer);

    /**
     * authority = unreserved | escaped | sub-delims
     * 
     * Note: we don`t allow escaped here since we will escape it ourselves, so we don`t want to allow them in the
     * unescaped sequences.
     * Note: we don't allow ':' in userinfo as that's the user/pass delimiter
     * Note: this class doesn't exist but represents the value used for user/pass/reg-name (NOT for IPLiteral)
     */
    BitSet authority = BitSet();
    
    authority.or(unreserved);
    authority.or(sub_delims);

    /**
     * pchar = unreserved | escaped | sub-delims | ":" | "@"
     * 
     * Note: we don`t allow escaped here since we will escape it ourselves, so we don`t want to allow them in the
     * unescaped sequences
     */
    BitSet pchar = BitSet();
    
    pchar.or(unreserved);
    pchar.or(sub_delims);
    pchar.set(':'.integer);
    pchar.set('@'.integer);

    /**
     * path_segment = pchar <without> ";"
     */
    BitSet path_segment = BitSet();
    
    path_segment.or(pchar);
    // deviate from the RFC in order to disallow the path param separator
    path_segment.clear(';'.integer);

    /**
     * path_param_name = pchar <without> ";" | "="
     */
    BitSet path_param_name = BitSet();
    
    path_param_name.or(pchar);
    // deviate from the RFC in order to disallow the path param separators
    path_param_name.clear(';'.integer);
    path_param_name.clear('='.integer);

    /**
     * path_param_value = pchar <without> ";"
     */
    BitSet path_param_value = BitSet();
    
    path_param_value.or(pchar);
    // deviate from the RFC in order to disallow the path param separator
    path_param_value.clear(';'.integer);

    /**
     * query = pchar / "/" / "?"
     */
    BitSet query = BitSet();
    
    query.or(pchar);
    query.set('/'.integer);
    query.set('?'.integer);
    // deviate from the RFC to disallow separators such as "=", "@" and the famous "+" which is treated as a space
    // when decoding
    query.clear('='.integer);
    query.clear('&'.integer);
    query.clear('+'.integer);

    /**
     * fragment = pchar / "/" / "?"
     */
    BitSet fragment = BitSet();
    
    fragment.or(pchar);
    fragment.set('/'.integer);
    fragment.set('?'.integer);

    "Percent-encodes a string for use in an authority/user URI part"
    shared String encodeUser(String str){
        return encodePart(str, "UTF-8", authority);
    }

    "Percent-encodes a string for use in an authority/password URI part"
    shared String encodePassword(String str){
        return encodePart(str, "UTF-8", authority);
    }

    "Percent-encodes a string for use in an authority/regName URI part (host name or IPV4Literal)"
    shared String encodeRegName(String str){
        return encodePart(str, "UTF-8", authority);
    }
    
    "Percent-encodes a string for use in an path/segment name URI part"
    shared String encodePathSegmentName(String str){
        return encodePart(str, "UTF-8", path_segment);
    }

    "Percent-encodes a string for use in an path/segment parameter name URI part"
    shared String encodePathSegmentParamName(String str){
        return encodePart(str, "UTF-8", path_param_name);
    }

    "Percent-encodes a string for use in an path/segment parameter value URI part"
    shared String encodePathSegmentParamValue(String str){
        return encodePart(str, "UTF-8", path_param_value);
    }
    
    "Percent-encodes a string for use in an query parameter name or value URI part"
    shared String encodeQueryPart(String str){
        return encodePart(str, "UTF-8", query);
    }

    "Percent-encodes a string for use in a fragment URI part"
    shared String encodeFragment(String str){
        return encodePart(str, "UTF-8", fragment);
    }
    
    String encodePart(String str, String encoding, BitSet allowed){
        StringBuilder encoded = StringBuilder();
        for (Character c in str) {
            if (allowed.get(c.integer)) {
                encoded.append(c.string);
            }
            else {
                ByteArray bytes = JString(c.string).getBytes(encoding);
                variable Integer idx = 0;
                while (idx < bytes.size) {
                    encoded.append(format("%%%1$02X", JByte(bytes.get(idx++))));
                }
            }
        }
        return encoded.string;
    }
}
