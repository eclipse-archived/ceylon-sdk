"""This package contains everything required to convert bytes to [[String]]s
   according to character sets.
   
   To convert a [[String]] to an ASCII byte [[ceylon.language::Array]]:
   
       Array<Byte> bytes = ascii.encode("Hello, World!");
   
   Now, if you want to decode it back:
   
       String string = ascii.decode(bytes);
       
   Similarly, for a [[ceylon.buffer::ByteBuffer]]:
   
       ByteBuffer bytes = utf8.encodeBuffer("Clear Air Turbulence");
       CharacterBuffer chars = utf8.decodeBuffer(bytes);
   
   If you only know the name of a charset you can get its Charset with:
   
       Charset? charset = charsetsByAlias["UTF-8"];
   """
by ("Stéphane Épardaud", "Alex Szczuczko")
shared package ceylon.buffer.charset;
