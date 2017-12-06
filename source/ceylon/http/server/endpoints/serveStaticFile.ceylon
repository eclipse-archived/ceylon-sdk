/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.file {
    Path,
    File,
    parsePath
}
import ceylon.io {
    newOpenFile,
    OpenFile
}
import ceylon.http.common {
    contentType,
    contentLength,
    Header
}
import ceylon.http.server {
    Response,
    Request,
    ServerException
}

"Endpoint for serving static files. _Must_ be attached to an
 [[ceylon.http.server::AsynchronousEndpoint]].
 
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
                void onError(ServerException e, Request r) => noop(e,r),
                {Header*} headers(File file) => {})
        (Request request, Response response, void complete()) {
    
    Path filePath = parsePath(externalPath + fileMapper(request));
    if (is File file = filePath.resource) {
        //TODO log
        //print("Serving file: ``filePath.absolutePath.string``");
        
        response.addHeader(contentLength(file.size.string));
        if (exists type = file.contentType) {
            response.addHeader(contentType(type));
        }
        
        response.addHeader(Header("ETag", 
            file.lastModifiedMilliseconds.string));
        
        for (header in headers(file)) {
            response.addHeader(header);
        }
        
        if (exists etag = request.header("If-None-Match"), 
            etag == file.lastModifiedMilliseconds.string) {
            response.status = 304;
        }
        else {
            value openFile = newOpenFile(file);
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
        }
        
    } else {
        response.status = 404;
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
