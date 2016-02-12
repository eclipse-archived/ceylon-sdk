import ceylon.file {
    File,
    Path,
    parsePath,
    Nil,
    createZipFileSystem
}
import ceylon.io {
    newOpenFile,
    OpenFile,
    stringToByteProducer
}
import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.charset {
    utf8
}
import ceylon.test {
    assertEquals,
    test
}

test void testFileCreateWriteRead(){
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
    value decoder = utf8.cumulativeDecoder();
	file2.readFully((ByteBuffer buffer) => decoder.more(buffer));
	file2.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done().string;
	assertEquals("Hello World\n", ret);
}

test void testFileCreateWriteReadWithoutReopen(){
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
	file.position = 0;
	assertEquals(0, file.position);
	assertEquals(12, file.size);
    value decoder = utf8.cumulativeDecoder();
	file.readFully((ByteBuffer buffer) => decoder.more(buffer));
	file.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done().string;
	assertEquals("Hello World\n", ret);
}

test void testFileCreateWriteResetWriteRead(){
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
	file.position = 0;
	file.writeFrom(stringToByteProducer(utf8, "olleH"));
	assertEquals(5, file.position);
	assertEquals(12, file.size);
	
	// reset it and read it
	file.position = 0;
	assertEquals(0, file.position);
	assertEquals(12, file.size);
    value decoder = utf8.cumulativeDecoder();
	file.readFully((ByteBuffer buffer) => decoder.more(buffer));
	file.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done().string;
	assertEquals("olleH World\n", ret);
}

test void testFileTruncate(){
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
	file.position = 0;
	file.truncate(5);
	assertEquals(0, file.position);
	assertEquals(5, file.size);
    value decoder = utf8.cumulativeDecoder();
	file.readFully((ByteBuffer buffer) => decoder.more(buffer));
	file.close();

	if(is File f = path.resource){
		// clean it up for next time
		f.delete();
	}
	
	String ret = decoder.done().string;
	assertEquals("Hello", ret);
}

test void testZipProviderMismatchException(){
	// create a new zip file and write to it
	Path path = parsePath("foo.zip");
	
	if(is File f = path.resource){
		// clean it up just in case
		f.delete();
	}
	
	value zip = path.resource;
	assert(is Nil zip);
	value system = createZipFileSystem(zip);
	try {
		value root = system.rootPaths.first;
		assert(exists root);
		root.childPath("toto");
	} finally {
		system.close();
		if(is File f = path.resource){
			// clean it up for next time
			f.delete();
		}
	}
}
