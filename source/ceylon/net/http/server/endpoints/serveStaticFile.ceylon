import ceylon.file { Path, File, parsePath }
import ceylon.io { newOpenFile, OpenFile }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.net.http.server { Response, Request, SendCallback, Exception }
import ceylon.net.http { contentType, contentLength }


"Endpoint for serving static files."
by("Matej Lazar")
shared void serveStaticFile(externalPath, String fileMapper(Request request) => request.path)
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

        FileWritter(openFile, response, onComplete).send();

    } else {
        response.responseStatus=404;
        //TODO log
        //print("file does not exist");
    }
}

class FileWritter(OpenFile openFile, Response response, void completed()) {
    variable Integer available = openFile.size;
    ByteBuffer byteBuffer = newByteBuffer(10);

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
        object writeComplete satisfies SendCallback {
            shared actual void onCompletion(Response response) {
                byteBuffer.clear();
                read();
            }
            shared actual void onError(Response response, Exception exception) {
                //TODO log
                print("Error writting file." + exception.string);
                completed();
            }
        }
        response.writeByteBufferAsynchronous(byteBuffer, writeComplete);
    }
}
