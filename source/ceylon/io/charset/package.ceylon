"This package contains everything required to convert bytes 
 to [[String]]s according to character sets.
 
 Sample code for converting a [[String]] to an ASCII 
 [[ceylon.io.buffer::ByteBuffer]]
 
     ByteBuffer buffer = ascii.encode(\"Hello World\");
 
 Now if you want to decode it back:
 
      String hello = ascii.decode(buffer);
 
 If you want to decode something according to any encoding:
 
     String decode(String encoding, ByteBuffer buffer){
         Charset? charset = getCharset(encoding);
         if(exists charset){
             return charset.decode(buffer);
         }
         throw Exception(\"Unknown character set\");
     }
 "
by("Stéphane Épardaud")
shared package ceylon.io.charset;