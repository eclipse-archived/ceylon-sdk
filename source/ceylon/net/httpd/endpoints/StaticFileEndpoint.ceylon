import ceylon.net.httpd { HttpResponse, CompletionHandler, HttpRequest, InternalException }
import ceylon.file { Path, File, parsePath }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.io { newOpenFile }


by "Matej Lazar"
shared class StaticFileEndpoint() {
    
    doc "root dir of external (not from .car) location"
    shared variable String? externalPath = null;
    
    //TODO onec we decide how to pack static files
    variable String carPath = "static";
    
    shared void service(HttpRequest request, HttpResponse response, CompletionHandler completionHandler) {
        String path = request.relativePath();
        
        if (exists filesLocation = externalPath) {
            //TODO serve files from car
            Path filePath = parsePath(filesLocation + path);
            if (is File file = filePath.resource) {
                //TODO log
                print("Serving file: ``filePath.absolutePath.string``");
                
	            value openFile = newOpenFile(file);
                
                try {
                    variable Integer available = file.size;
                    response.addHeader("content-length", available.string);
                    if (is String cntType = file.contentType) {
                        response.addHeader("content-type", cntType);
                    }
                    
                    //TODO transfer bytes efficiently between two channels. Use org.xnio.channels.Channels.transferBlocking
                    //use completionHandler to notify request complete
                    ByteBuffer buffer = newByteBuffer(available);
                    //while (available > 0) {
                    value read = openFile.read(buffer);
                    //available -= read;
                    response.writeBytes(buffer.bytes());
                    //buffer.flip();
                    //}
                } finally {
                    openFile.close();
                }
            } else {
                response.responseStatus(404);
                //TODO log
                print("file does not exist");
            }
        } else {
            throw InternalException("Root dir of files must be set. Make shure that StaticFileEndpoint.externalPath is set.");
        }
        completionHandler.handleComplete();
    }
}