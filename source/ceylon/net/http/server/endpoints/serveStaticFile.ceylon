import ceylon.file {
    Path,
    File,
    parsePath
}
import ceylon.io {
    newOpenFile,
    OpenFile
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

"Endpoint for serving static files. _Must_ be attached to an
 [[ceylon.net.http.server::AsynchronousEndpoint]].
 
 For example:
 
     shared void run() 
            => newServer {
        AsynchronousEndpoint {
            path = startsWith(\"/ceylon-ide\");
            acceptMethod = { get };
            service = serveStaticFile {
                externalPath = \"web-content\";
                fileMapper(Request request)
                        => request.path.replace(\"/ceylon-ide\", \"\");
            };
        }
     };"
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
                onSuccess(request);
                complete();
            }
            void onError(ServerException exception) {
                openFile.close();
                response.flush();
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
    response.transferFileAsynchronous(openFile, onSuccess, onError);
}
