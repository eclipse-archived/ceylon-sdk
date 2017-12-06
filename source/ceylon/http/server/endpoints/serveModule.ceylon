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
    File
}
import ceylon.http.common {
    Header
}
import ceylon.http.server {
    Request,
    Response,
    ServerException
}

import org.eclipse.ceylon.cmr.api {
    RepositoryManager,
    ArtifactContext {
        getSuffixFromFilename
    }
}

"""Service function for sending Ceylon modules to the client. _Must_ be attached
   to an [[ceylon.http.server::AsynchronousEndpoint]].
   
   For example:
   
       shared void run() { 
          value extraRepo = Collections.singletonList("/custom/path/to/modules");
          value manager = CeylonUtils
              .repoManager()
              .extraUserRepos(extraRepo)
              .buildManager();
   
          value server = newServer {
              AsynchronousEndpoint {
                  path = startsWith("/modules");
                  acceptMethod = { get };
                  service = serveModule {
                      manager = manager;
                      contextRoot = "/modules";
                  };
              }
          };
       }"""
by("Bastien Jansen", "Tako Schotanus")
shared void serveModule(
            "The repository manager used to look for artifacts"
            RepositoryManager manager,
            "The context root associated to the endpoint, e.g `/modules`."
            String contextRoot,
            Options options = Options(),
            void onSuccess(Request r) => noop(r),
            void onError(ServerException e, Request r) => noop(e,r),
            {Header*} headers(File file) => {})
        (Request req, Response resp, void complete()) {

    // Make sure the root path ends with a slash
    value root
            = contextRoot.endsWith("/")
            then contextRoot
            else contextRoot + "/";
    
    // req.path == "/modules/ceylon.language-1.2.0.js" or
    // req.path == "/modules/ceylon/language/1.2.0/ceylon.language-1.2.0.js"
    // first we strip the context root and the leading slash
    value reqPath = req.path;
    value path = reqPath[root.size...];

    if (reqPath.startsWith(root),
            exists ac = getArtifactContext(path),
            exists file = findArtifactPath(manager, ac)) {
        serveStaticFile {
            externalPath = "";
            fileMapper(Request req) => file;
            options = options;
            onSuccess = onSuccess;
            onError = onError;
            headers = headers;
        }(req, resp, complete);
    } else {
        resp.status = 404;
        resp.writeString("404 - Not found");
    }
}

ArtifactContext? getArtifactContext(String path) {
    try {
        String? namespace = null; //TODO!!
        // path == "ceylon.language-1.2.0.js" or
        // path == "ceylon/language/1.2.0/ceylon.language-1.2.0.js"
        value parts = path.split('/'.equals, true, false).sequence();
        value size = parts.size;

        value fileName = parts.last;

        if (size == 1) {
            // parts == [ceylon.language-1.2.0.js]
            if (exists p = fileName.firstOccurrence('-')) {
                assert (exists suffix = getSuffixFromFilename(fileName));
                value name = fileName[0..p-1];
                value version = fileName[p+1:fileName.size-name.size-suffix.size-1];
                return ArtifactContext(namespace, name, version, suffix);
            }
        }
        else if (size >= 3) {
            // parts == [ceylon, language, 1.2.0, ceylon.language-1.2.0.js]
            value name = ".".join(parts[0..size-3]);
            // name == "ceylon.language"
            value version = parts[size - 2] else "";
            assert (exists suffix = getSuffixFromFilename(parts.last));
            if (fileName == name + "-" + version + suffix) {
                return ArtifactContext(namespace, name, version, suffix);
            }
        }
    }
    catch (ex) { }
    return null;
}

String? findArtifactPath(RepositoryManager manager,
    ArtifactContext context) {
    
    if (exists artifact = manager.getArtifact(context),
            artifact.\iexists(),
            artifact.file) {
        return artifact.absolutePath;
    }
    else if (!context.namespace exists) {
        // Try again with the NPM namespace
        context.namespace = "npm";
        if (exists artifact = manager.getArtifact(context),
                artifact.\iexists(),
                artifact.file) {
            return artifact.absolutePath;
        }
    }
    return null;
}
