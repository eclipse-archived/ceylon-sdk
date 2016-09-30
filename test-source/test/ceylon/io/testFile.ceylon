import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.charset {
    utf8
}
import ceylon.file {
    File,
    Nil,
    createZipFileSystem,
    temporaryDirectory
}
import ceylon.io {
    newOpenFile,
    OpenFile,
    stringToByteProducer
}
import ceylon.test {
    assertEquals,
    test
}

test void testFileCreateWriteRead(){
    
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        // create a new file and write to it
        value path = tmpDir.path.childPath("foo.txt");
    	
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
}

test void testFileCreateWriteReadWithoutReopen(){
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        // create a new file and write to it
        value path = tmpDir.path.childPath("foo.txt");
    	
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
}

test void testFileCreateWriteResetWriteRead(){
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        // create a new file and write to it
        value path = tmpDir.path.childPath("foo.txt");
    	
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
}

test void testFileTruncate(){
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        // create a new file and write to it
        value path = tmpDir.path.childPath("foo.txt");
	
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
}

test void testZipProviderMismatchException(){
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        // create a new file and write to it
        value path = tmpDir.path.childPath("foo.zip");
	
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
}

shared test
void writeLargeStringToFile() {
    try (tmpDir = temporaryDirectory.TemporaryDirectory(null)) {
        // generate a string bigger than the buffer used by writeFrom() 
        StringBuilder sb = StringBuilder();
        for (i in 0:430) {
            value x = sb.size;
            sb.append((i*10).string);
            for (j in 0:10-(sb.size-x)-1) {
                sb.appendCharacter('.');
            }
            sb.appendCharacter('\n');
        }
        // write that string to a file
        value str = sb.string;
        variable OpenFile file = newOpenFile(tmpDir.path.childPath("test.ceylon.io.writeLargeStringToFile.txt").resource);
        file.writeFrom(stringToByteProducer(utf8, str));
        file.close();
        
        // now read it back
        value decoder = utf8.cumulativeDecoder();
        file = newOpenFile(tmpDir.path.childPath("test.ceylon.io.writeLargeStringToFile.txt").resource);
        file.readFully(decoder.more);
        value got = decoder.done().string;
        file.close();
        
        // they should be the same, right?
        assertEquals{
            expected = str;
            actual = got;
        };
        
        if (is File f=tmpDir.path.childPath("test.ceylon.io.writeLargeStringToFile.txt").resource) {
            f.delete();
        }
    }
}