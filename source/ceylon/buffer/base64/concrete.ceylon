Map<Element,Byte> toReverseTable<Element>([Element+] table)
        given Element satisfies Object {
    return map { for (i->c in table.indexed) c->i.byte };
}

[Character+] standardCharTable = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/'];
Map<Character,Byte> standardReverseCharTable = toReverseTable(standardCharTable);
"The Basic type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64StringStandard extends Base64String() {
    shared actual [Character+] table = standardCharTable;
    shared actual Map<Character,Byte> reverseTable = standardReverseCharTable;
    shared actual [String+] aliases = ["base64", "base-64", "base_64"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
}

[Character+] urlCharTable = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '-', '_'];
Map<Character,Byte> urlReverseCharTable = toReverseTable(urlCharTable);
"The URL and Filename safe type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64StringUrl extends Base64String() {
    shared actual [Character+] table = urlCharTable;
    shared actual Map<Character,Byte> reverseTable = urlReverseCharTable;
    shared actual [String+] aliases = ["base64url", "base-64-url", "base_64_url"];
    shared actual Integer encodeBid({Byte*} sample) => 5;
}

[Byte+] standardByteTable = standardCharTable*.integer*.byte;
Map<Byte,Byte> standardReverseByteTable = toReverseTable(standardByteTable);
"The Basic type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64ByteStandard extends Base64Byte() {
    shared actual [Byte+] table = standardByteTable;
    shared actual Map<Byte,Byte> reverseTable = standardReverseByteTable;
    shared actual [String+] aliases = ["base64", "base-64", "base_64"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
}

[Byte+] urlByteTable = urlCharTable*.integer*.byte;
Map<Byte,Byte> urlReverseByteTable = toReverseTable(urlByteTable);
"The URL and Filename safe type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64ByteUrl extends Base64Byte() {
    shared actual [Byte+] table = urlByteTable;
    shared actual Map<Byte,Byte> reverseTable = urlReverseByteTable;
    shared actual [String+] aliases = ["base64url", "base-64-url", "base_64_url"];
    shared actual Integer encodeBid({Byte*} sample) => 5;
}
