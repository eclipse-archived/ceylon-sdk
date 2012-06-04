package ceylon.fs.internal;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;
import static java.nio.file.StandardOpenOption.APPEND;
import static java.nio.file.StandardOpenOption.TRUNCATE_EXISTING;
import static java.nio.file.StandardOpenOption.WRITE;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

class Util {
    public static Path newPath(String pathString) {
    	return Paths.get(pathString);
    }
    public static Path copyPath(Path source, Path target) 
    		throws IOException {
    	return Files.copy(source, target);
    }
    public static void deletePath(Path path) 
    		throws IOException {
    	Files.delete(path);
    }
    public static Path movePath(Path source, Path target) 
    		throws IOException {
    	return Files.move(source, target);
    }
    public static Path overwritePath(Path source, Path target) 
    		throws IOException {
    	return Files.move(source, target, REPLACE_EXISTING);
    }
    public static Path copyAndOverwritePath(Path source, Path target) 
    		throws IOException {
    	return Files.copy(source, target, REPLACE_EXISTING);
    }
    public static Path newDirectory(Path path) 
    		throws IOException {
    	return Files.createDirectories(path);
    }
    public static Path newFile(Path path) 
    		throws IOException {
    	Files.createDirectories(path.getParent());
    	return Files.createFile(path);
    }
    public static boolean isExisting(Path path) {
    	return Files.exists(path);
    }
    public static boolean isRegularFile(Path path) {
    	return Files.isRegularFile(path);
    }
    public static boolean isDirectory(Path path) {
    	return Files.isDirectory(path);
    }
    public static long getLastModified(Path path) throws IOException {
    	return Files.getLastModifiedTime(path).toMillis();
    }
    public static BufferedReader newReader(Path path, String cs) 
    		throws IOException {
    	return Files.newBufferedReader(path, cs==null ? 
    			Charset.defaultCharset() : Charset.forName(cs));
    }
    public static BufferedWriter newWriter(Path path, String cs) 
    		throws IOException {
    	return Files.newBufferedWriter(path, cs==null ? 
    			Charset.defaultCharset() : Charset.forName(cs),
    			WRITE, TRUNCATE_EXISTING);
    }
    public static BufferedWriter newAppendingWriter(Path path, String cs) 
    		throws IOException {
    	return Files.newBufferedWriter(path, cs==null ? 
    			Charset.defaultCharset() : Charset.forName(cs),
    			WRITE, APPEND);
    }
}
