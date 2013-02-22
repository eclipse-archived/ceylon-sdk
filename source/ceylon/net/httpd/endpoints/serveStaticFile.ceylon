import ceylon.file { Path, File, parsePath }
import ceylon.io { newOpenFile }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.net.httpd { Response, Request }
import ceylon.net.http { contentType, contentLength }


by "Matej Lazar"
shared void serveStaticFile(externalPath)
        (Request request, Response response, void completionHandler()) {
    
    doc "Root directory containing files."
    String externalPath;
    
    Path filePath = parsePath(externalPath + request.relativePath);
    if (is File file = filePath.resource) {
        //TODO log
        //print("Serving file: ``filePath.absolutePath.string``");
        
        value openFile = newOpenFile(file);
        try {
            Integer available = file.size;
            response.addHeader(contentLength(available.string));
            if (is String cntType = file.contentType) {
                response.addHeader(contentType(cntType));
            }
            
            //TODO transfer bytes efficiently between two channels. 
            //     using org.xnio.channels.Channels.transferBlocking
            //use completionHandler to notify request complete
            ByteBuffer buffer = newByteBuffer(available);
            //while (available > 0) {
            value read = openFile.read(buffer);
            //available -= read;
            response.writeBytes(buffer.bytes());
            //buffer.flip();
        } finally {
            openFile.close();
        }
    } else {
        response.responseStatus=404;
        //TODO log
        //print("file does not exist");
    }
    
    completionHandler();
    
}