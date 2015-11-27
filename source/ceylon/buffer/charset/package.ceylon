"""This package contains everything required to convert bytes to [[String]]s
   according to character sets.
   
   To convert a [[String]] to an ASCII byte [[ceylon.language::Array]]:
   
       Array<Byte> bytes = ascii.encode("Hello, World!");
   
   Now, if you want to decode it back:
   
       String string = ascii.decode(bytes);
       
   Similarly, for a [[ceylon.buffer::ByteBuffer]] that's ok to resize:
   
       ByteBuffer bytes = ByteBuffer.ofSize(0);
       utf8.encodeInto(bytes, "Clear Air Turbulence");
       CharacterBuffer chars = CharacterBuffer.ofSize(0);
       utf8.decodeInto(chars, bytes);
       
   Or for one that must stay a fixed size:
   
       ByteBuffer bytes = ByteBuffer.ofSize(1M);
       value encoder = utf8.chunkEncoder();
       encoder.convert(bytes, "No More Mr Nice Guy");
   
   If you only know the name of a charset you can get its Charset with:
   
       Charset? charset = charsetsByAlias["UTF-8"];
   """
by ("Stéphane Épardaud", "Alex Szczuczko")
shared package ceylon.buffer.charset;
