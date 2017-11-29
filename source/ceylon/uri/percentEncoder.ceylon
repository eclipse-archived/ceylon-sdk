/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer.charset {
    charsetsByAlias
}

"Contains methods for percent-encoding. 
     See http://tools.ietf.org/html/rfc3986#appendix-A for specifications."
by("Stéphane Épardaud")
shared object percentEncoder {

    """gen-delims = ":" / "/" / "?" / "#" / "[" / "]" / "@"
    """
    Boolean isGenDelim(Character c); 
    isGenDelim = set {
        ':', '/', '?', '#', '[', ']', '@'
    }.contains;

    """sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
    """
    Boolean isSubDelim(Character c);
    isSubDelim = set {
        '!', '$', '&', '\'', '(', ')', '*', '+', ',', ';', '='
    }.contains;

    // """reserved = gen-delims | sub-delims"""
    // function isReserved(Character c)
    //         => isGenDelim(c) || isSubDelim(c);

    """lowalpha = 'a'..'z'"""
    function isLowAlpha(Character c)
            => 'a' <= c <= 'z';

    """upalpha = 'A'..'Z'"""
    function isUpAlpha(Character c)
            => 'A' <= c <= 'Z';

    """alpha = lowalpha | upalpha"""
    function isAlpha(Character c)
            => isLowAlpha(c) || isUpAlpha(c);

    """digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
    """ 
    function isDigit(Character c)
            => '0' <= c <= '9';

    """alphanum = alpha | digit"""
    function isAlphaNum(Character c)
            => isAlpha(c) || isDigit(c);

    """unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
    """
    function isUnreserved(Character c)
            => isAlphaNum(c)
                // || c in ['-', '.', '_', '~'];
                || c == '-'
                || c == '.'
                || c == '_'
                || c == '~';

    """authority = unreserved | escaped | sub-delims

       - Note: we don`t allow escaped here since we will escape it ourselves, so we don`t want to allow them in the
         unescaped sequences.
       - Note: we don't allow ':' in userinfo as that's the user/pass delimiter
       - Note: this class doesn't exist but represents the value used for user/pass/reg-name (NOT for IPLiteral)"""
    function isAuthority(Character c)
            => isUnreserved(c) || isSubDelim(c);

    """pchar = unreserved | escaped | sub-delims | ":" | "@"
       
       Note: we don`t allow escaped here since we will escape it ourselves, so we don`t want to allow them in the
       unescaped sequences
    """
    function isPChar(Character c)
            => isUnreserved(c) || isSubDelim(c) || c == ':' || c == '@';

    """path_segment = pchar <without> ";"
    """
    function isPathSegment(Character c)
            => isPChar(c)
            // deviate from the RFC in order to disallow the path param separator
            && c != ';';

    """path_param_name = pchar <without> ";" | "="
    """
    function isPathParamName(Character c)
            => isPChar(c)
            // deviate from the RFC in order to disallow the path param separators
            // && !c in [';', '='];
            && c != ';' && c != '=';

    """path_param_value = pchar <without> ";"
    """
    function isPathParamValue(Character c)
            => isPChar(c)
            // deviate from the RFC in order to disallow the path param separator
            && !c == ';';

    """query = pchar / "/" / "?"
    """
    function isQuery(Character c)
            => (isPChar(c) || c == '/' || c == '?')
            // deviate from the RFC to disallow separators such as "=", "@" and the famous "+" which is treated as a space
            // when decoding
            && c != '=' && c != '&' && c != '+';

    """fragment = pchar / "/" / "?"
    """
    function isFragment(Character c)
            => isPChar(c) || c == '/' || c == '?';

    "Percent-encodes a string for use in an authority/user URI part"
    shared String encodeUser(String str)
            => encodePart(str, "UTF-8", isAuthority);

    "Percent-encodes a string for use in an authority/password URI part"
    shared String encodePassword(String str)
            => encodePart(str, "UTF-8", isAuthority);

    "Percent-encodes a string for use in an authority/regName URI part (host name or IPV4Literal)"
    shared String encodeRegName(String str)
            => encodePart(str, "UTF-8", isAuthority);
    
    "Percent-encodes a string for use in an path/segment name URI part"
    shared String encodePathSegmentName(String str) {
        return encodePart(str, "UTF-8", isPathSegment);
    }

    "Percent-encodes a string for use in an path/segment parameter name URI part"
    shared String encodePathSegmentParamName(String str)
            => encodePart(str, "UTF-8", isPathParamName);

    "Percent-encodes a string for use in an path/segment parameter value URI part"
    shared String encodePathSegmentParamValue(String str)
            => encodePart(str, "UTF-8", isPathParamValue);
    
    "Percent-encodes a string for use in an query parameter name or value URI part"
    shared String encodeQueryPart(String str)
            => encodePart(str, "UTF-8", isQuery);

    "Percent-encodes a string for use in a fragment URI part"
    shared String encodeFragment(String str)
            => encodePart(str, "UTF-8", isFragment);
    
    String encodePart(String str, String encoding, Boolean allowed(Character c)) {
        value encoded = StringBuilder();
        for (c in str) {
            if (allowed(c)) {
                encoded.append(c.string);
            }
            else {
                value charset = charsetsByAlias[encoding];
                if (!exists charset) {
                    throw AssertionError("Encoding not supported: '``encoding``'");
                }
                value bytes = charset.encode(c.string);
                for (byte in bytes) {
                    encoded.appendCharacter('%');
                    encoded.append(Integer.format(byte.unsigned, 16)
                        .uppercased.pad(2, '0'));
                }
            }
        }
        return encoded.string;
    }
}
