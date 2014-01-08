import ceylon.io.buffer { ByteBuffer}
import ceylon.io.charset { utf8 }


class TestBase64(){

 
 print(base64.encode("pleasure.","utf8"));
 print(base64.encode("leasure.","utf8"));
 print(base64.encode("easure.","utf8"));
 print(base64.encode("asure.","utf8"));
 print(base64.encode("sure.","utf8"));
 print(base64.encode("asure."));
 print(base64.encode("sure."));
 print(base64.encode("sure.","utf8"));
 print(base64.encode("any carnal pleas"));
 print(base64.encode("Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the shortvehemence of any carnal pleasure.", "utf8"));
 

print(base64.decode("cGxlYXN1cmUu","utf8"));
print(base64.decode("bGVhc3VyZS4=","utf8"));
print(base64.decode("ZWFzdXJlLg==","utf8"));
print(base64.decode("YXN1cmUu","utf8"));
print(base64.decode("c3VyZS4=","utf8"));
print(base64.decode("YW55IGNhcm5hbCBwbGVhcw==","utf8"));
print(base64.decode("YW55IGNhcm5hbCBwbGVhc3U="));

print(base64.decode("YW55IGNhcm5hbCBwbGVhc3Vy"));
print(base64.decode("TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGludWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRoZSBzaG9ydHZlaGVtZW5jZSBvZiBhbnkgY2FybmFsIHBsZWFzdXJlLg=="));
 
 
 /*TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz
 IHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2Yg
  dGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGlu
  dWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRo
  ZSBzaG9ydHZlaGVtZW5jZSBvZiBhbnkgY2FybmFsIHBsZWFzdXJlLg==*/
 
 
/* TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz
IHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2Yg
dGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGlu
dWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRo
ZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=*/


	/*cGxlYXN1cmUu
bGVhc3VyZS4=
ZWFzdXJlLg==
cGxlYXN1cmUu
YXN1cmU=
c3VyZS4=*/
	
	/*The input: pleasure.   Encodes to: cGxlYXN1cmUu
The input: leasure.    Encodes to: bGVhc3VyZS4=
The input: easure.     Encodes to: ZWFzdXJlLg==
The input: asure.      Encodes to:     YXN1cmUu
The input: sure.       Encodes to:     c3VyZS4=*/
}