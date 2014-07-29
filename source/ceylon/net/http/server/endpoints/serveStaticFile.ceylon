import ceylon.file { Path, File, parsePath }
import ceylon.io { newOpenFile, OpenFile }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.net.http.server { Response, Request, ServerException }
import ceylon.net.http { contentType, contentLength }


"Endpoint for serving static files."
by("Matej Lazar")
shared void serveStaticFile(
                externalPath, 
                String fileMapper(Request request) => request.path,
                Options options = Options(),
                Anything(Request)? onSuccess = null,
                Anything(ServerException,Request)? onError = null)
        (Request request, Response response, Anything() complete) {
    
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

        void _onSuccess() {
            openFile.close();
            if (exists onSuccess) {
                onSuccess(request);
            }
            complete();
        }

        void _onError(ServerException exception) {
            openFile.close();
            if (exists onError) {
                onError(exception,request);
            }
            complete();
        }

        FileWriter(openFile, response, options, _onSuccess, _onError).send();

    } else {
        response.responseStatus=404;
        //TODO log
        print("File ``filePath.absolutePath.string`` does not exist.");
    }
}

class FileWriter(OpenFile openFile, Response response, Options options, void onSuccess(), void onError(ServerException exception)) {
    variable Integer available = openFile.size;
    variable Integer readFailed = 0;
    Integer bufferSize = options.outputBufferSize < available then options.outputBufferSize else available;
    ByteBuffer byteBuffer = newByteBuffer(bufferSize);

    shared void send() {
        read();
    }

    void read() {
        if (available > 0) {
            try {
                value read = openFile.read(byteBuffer);
                if (read == -1) {
                    available = 0;
                } else if (read == 0) {
                    readFailed ++;
                    if (readFailed > options.readAttempts) {
                        onError(ServerException("Error reading file ``openFile.resource.path``."));
                        return;
                    }
                } else {
                    available -= read;
                    readFailed = 0;
                }
                byteBuffer.flip();
                write(onError);
            } catch (ServerException e) {
                onError(e);
            }
        } else {
            onSuccess();
        }
    }
    
    void write(void onError(ServerException exception)) {
        void onCompletion() {
            byteBuffer.clear();
            read();
        }
        response.writeByteBufferAsynchronous(byteBuffer, onCompletion, onError);
    }
}
