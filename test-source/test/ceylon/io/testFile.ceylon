import ceylon.file { File, Path, parsePath }
import ceylon.io { newOpenFile, OpenFile }
import ceylon.io.charset { utf8, byteConsumerToStringConsumer, stringToByteProducer, Decoder }
import ceylon.io.buffer { ByteBuffer }
import ceylon.test { assertEquals }

void testFileCreateWriteRead(){
	// create a new file and write to it
	Path path = parsePath("foo.txt");
	
	if(is File f = path.resource){
		// clean it up just in case
		f.delete();
	}
	
	OpenFile file = newOpenFile(path.resource);
	assertEquals(0, file.position);
	assertEquals(0, file.size);
	file.writeFrom(stringToByteProducer(utf8, "Hello World\n"));
	assertEquals(12, file.position);
	assertEquals(12, file.size);
	file.close();
	
	// reopen it and read it
	OpenFile file2 = newOpenFile(path.resource);
	assertEquals(0, file2.position);
	assertEquals(12, file2.size);
    Decoder decoder = utf8.newDecoder();
	file2.readFully((ByteBuffer buffer) decoder.decode(buffer));
	file2.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done();
	assertEquals("Hello World\n", ret);
}

void testFileCreateWriteReadWithoutReopen(){
	// create a new file and write to it
	Path path = parsePath("foo.txt");
	
	if(is File f = path.resource){
		// clean it up just in case
		f.delete();
	}
	
	OpenFile file = newOpenFile(path.resource);
	assertEquals(0, file.position);
	assertEquals(0, file.size);
	file.writeFrom(stringToByteProducer(utf8, "Hello World\n"));
	assertEquals(12, file.position);
	assertEquals(12, file.size);
	
	// reset it and read it
	file.position := 0;
	assertEquals(0, file.position);
	assertEquals(12, file.size);
    Decoder decoder = utf8.newDecoder();
	file.readFully((ByteBuffer buffer) decoder.decode(buffer));
	file.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done();
	assertEquals("Hello World\n", ret);
}

void testFileCreateWriteResetWriteRead(){
	// create a new file and write to it
	Path path = parsePath("foo.txt");
	
	if(is File f = path.resource){
		// clean it up just in case
		f.delete();
	}
	
	OpenFile file = newOpenFile(path.resource);
	assertEquals(0, file.position);
	assertEquals(0, file.size);
	file.writeFrom(stringToByteProducer(utf8, "Hello World\n"));
	assertEquals(12, file.position);
	assertEquals(12, file.size);
	
	// reset it and change the start
	file.position := 0;
	file.writeFrom(stringToByteProducer(utf8, "olleH"));
	assertEquals(5, file.position);
	assertEquals(12, file.size);
	
	// reset it and read it
	file.position := 0;
	assertEquals(0, file.position);
	assertEquals(12, file.size);
    Decoder decoder = utf8.newDecoder();
	file.readFully((ByteBuffer buffer) decoder.decode(buffer));
	file.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done();
	assertEquals("olleH World\n", ret);
}

void testFileTruncate(){
	// create a new file and write to it
	Path path = parsePath("foo.txt");
	
	if(is File f = path.resource){
		// clean it up just in case
		f.delete();
	}
	
	OpenFile file = newOpenFile(path.resource);
	assertEquals(0, file.position);
	assertEquals(0, file.size);
	file.writeFrom(stringToByteProducer(utf8, "Hello World\n"));
	assertEquals(12, file.position);
	assertEquals(12, file.size);
	
	// truncate it and read it
	file.position := 0;
	file.truncate(5);
	assertEquals(0, file.position);
	assertEquals(5, file.size);
    Decoder decoder = utf8.newDecoder();
	file.readFully((ByteBuffer buffer) decoder.decode(buffer));
	file.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done();
	assertEquals("Hello", ret);
}
