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
                Options options = Options())
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

        FileWriter(openFile, response, onComplete, options).send();

    } else {
        response.responseStatus=404;
        //TODO log
        print("File ``filePath.absolutePath.string`` does not exist.");
    }
}

class FileWriter(OpenFile openFile, Response response, void completed(), Options options) {
    variable Integer available = openFile.size;
    variable Integer readFailed = 0;
    Integer bufferSize = options.outputBufferSize < available then options.outputBufferSize else available;
    ByteBuffer byteBuffer = newByteBuffer(bufferSize);

    shared void send() {
        read();
    }

    void read() {
        if (available > 0) {
            value read = openFile.read(byteBuffer);
            if (read == -1) {
                available = 0;
            } else if (read == 0) {
                readFailed ++;
                if (readFailed > 10) { //try to read 10 times
                    //TODO log
                    print("Error reading file ``openFile.resource.path``.");
                    completed();
                    return;
                }
            } else {
                available -= read;
                readFailed = 0;
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
