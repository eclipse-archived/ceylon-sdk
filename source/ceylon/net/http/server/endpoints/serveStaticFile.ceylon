import ceylon.file { Path, File, parsePath }
import ceylon.io { newOpenFile, OpenFile }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.net.http.server { Response, Request, Exception }
import ceylon.net.http { contentType, contentLength }


"Endpoint for serving static files."
by("Matej Lazar")
shared void serveStaticFile(
                externalPath, 
                String fileMapper(Request request) => request.path,
                EndpointOptions endpointOptions = EndpointOptions())
        (Request request, Response response, Callable<Anything, []> complete) {
    
    "Root directory containing files."
    String externalPath;
    
    Path filePath = parsePath(externalPath + fileMapper(request));
    if (is File file = filePath.resource) {
        //TODO log
        //print("Serving file: ``filePath.absolutePath.string``");
        
        value openFile = newOpenFile(file);

        variable Integer available = file.size;
        response.addHeader(contentLength(available.string));
        if (is String cntType = file.contentType) {
            response.addHeader(contentType(cntType));
        }

        void onComplete() {
            openFile.close();
            complete();
        }

        FileWritter(openFile, response, onComplete, endpointOptions).send();

    } else {
        response.responseStatus=404;
        //TODO log
        //print("file does not exist");
    }
}

class FileWritter(OpenFile openFile, Response response, void completed(), EndpointOptions endpointOptions) {
    variable Integer available = openFile.size;
    ByteBuffer byteBuffer = newByteBuffer(endpointOptions.outputBufferSize);

    shared void send() {
        read();
    }

    void read() {
        if (available > 0) {
            value read = openFile.read(byteBuffer);
            if (read == -1) {
                available = 0;
            } else {
                available -= read;
            }
            byteBuffer.flip();
            write();
        } else {
            completed();
        }
    }
    
    void write() {

        void onCompletion() {
            byteBuffer.clear();
            read();
        }
        void onError(Exception exception) {
            //TODO log
            print("Error writting file ``openFile.resource.path``: " + exception.string);
            completed();
        }
        response.writeByteBufferAsynchronous(byteBuffer, onCompletion, onError);
    }
}
