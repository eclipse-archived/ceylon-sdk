import ceylon.file {
    Path,
    File,
    parsePath
}
import ceylon.io {
    newOpenFile,
    OpenFile
}
import ceylon.io.buffer {
    newByteBuffer
}
import ceylon.net.http {
    contentType,
    contentLength
}
import ceylon.net.http.server {
    Response,
    Request,
    ServerException
}

"Endpoint for serving static files."
by("Matej Lazar")
shared void serveStaticFile(
                "Root directory containing files."
                String externalPath, 
                String fileMapper(Request request) => request.path,
                Options options = Options(),
                void onSuccess(Request r) => noop(r),
                void onError(ServerException e, Request r) => noop(e,r))
        (Request request, Response response, void complete()) {
    
    Path filePath = parsePath(externalPath + fileMapper(request));
    if (is File file = filePath.resource) {
        //TODO log
        //print("Serving file: ``filePath.absolutePath.string``");
        
        value openFile = newOpenFile(file);
        response.addHeader(contentLength(file.size.string));
        if (exists type = file.contentType) {
            response.addHeader(contentType(type));
        }
        
        sendFile {
            openFile = openFile;
            response = response;
            options = options;
            void onSuccess() {
                openFile.close();
                response.flush();
                response.close();
                onSuccess(request);
                complete();
            }
            void onError(ServerException exception) {
                openFile.close();
                response.flush();
                response.close();
                onError(exception,request);
                complete();
            }
        };
        
    } else {
        response.responseStatus = 404;
        //TODO log
        print("File ``filePath.absolutePath.string`` does not exist.");
        response.flush();
        response.close();
    }
}

void sendFile(
    OpenFile openFile, 
    Response response, 
    Options options, 
    void onSuccess(), 
    void onError(ServerException exception)
) {
    variable value available = openFile.size;
    variable value readFailed = 0;
    value bufferSize =
            options.outputBufferSize < available 
            then options.outputBufferSize else available;
    value byteBuffer = newByteBuffer(bufferSize);

    void read() {
        if (available > 0) {
            try {
                byteBuffer.clear();
                value bytesRead = openFile.read(byteBuffer);
                if (bytesRead<0) {
                    available = 0;
                    onSuccess();
                } else if (bytesRead == 0) {
                    readFailed ++;
                    if (readFailed > options.readAttempts) {
                        onError(ServerException("Error reading file ``openFile.resource.path``."));
                    }
                    else {
                    }
                } else {
                    available -= bytesRead;
                    readFailed = 0;
                    byteBuffer.flip();
                    response.writeByteBufferAsynchronous {
                        byteBuffer = byteBuffer;
                        onError = onError;
                        onCompletion = read;
                    };
                }
            } catch (ServerException e) {
                onError(e);
            }
        } else {
            onSuccess();
        }
    }
    
    read();
}
