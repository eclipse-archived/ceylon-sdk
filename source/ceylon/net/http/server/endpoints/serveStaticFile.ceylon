import ceylon.file { Path, File, parsePath }
import ceylon.io { newOpenFile }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.net.http.server { Response, Request }
import ceylon.net.http { contentType, contentLength }


"Endpoint for serving static files."
by("Matej Lazar")
shared void serveStaticFile(externalPath)
        (Request request, Response response, Callable<Anything, []> complete) {
    
    "Root directory containing files."
    String externalPath;
    
    Path filePath = parsePath(externalPath + request.path);
    if (is File file = filePath.resource) {
        //TODO log
        //print("Serving file: ``filePath.absolutePath.string``");
        
        value openFile = newOpenFile(file);
        try {
            variable Integer available = file.size;
            response.addHeader(contentLength(available.string));
            if (is String cntType = file.contentType) {
                response.addHeader(contentType(cntType));
            }

            ByteBuffer buffer = newByteBuffer(1024);
            while (available > 0) {
                value read = openFile.read(buffer);
                if (read == -1) {
                    available = 0;
                } else {
                    available -= read;
                }
                buffer.flip();
                response.writeByteBuffer(buffer);
                buffer.clear();
            }
        } finally {
            openFile.close();
        }
    } else {
        response.responseStatus=404;
        //TODO log
        //print("file does not exist");
    }
    
    complete();
}
