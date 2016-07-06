import ceylon.http.server {
    Request,
    Response,
    ServerException
}

import com.redhat.ceylon.cmr.api {
    RepositoryManager,
    ArtifactContext {
        getSuffixFromFilename
    }
}
import ceylon.http.common {
    Header
}
import ceylon.file {
    File
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
    value root = if (contextRoot.endsWith("/")) then contextRoot else contextRoot + "/";
    
    // req.path == "/modules/ceylon.language-1.2.0.js" or
    // req.path == "/modules/ceylon/language/1.2.0/ceylon.language-1.2.0.js"
    // first we strip the context root and the leading slash
    value path = req.path.spanFrom(root.size);
    
    ArtifactContext? ac = getArtifactContext(path);
    if (req.path.startsWith(root),
            exists ac,
            exists file = findArtifactPath(manager, ac)) {
        serveStaticFile("", (req) => file, options, onSuccess, onError, headers)
            (req, resp, complete);
    } else {
        resp.status = 404;
        resp.writeString("404 - Not found");
    }
}

ArtifactContext? getArtifactContext(String path) {
    try {
        String? namespace = null;
        // path == "ceylon.language-1.2.0.js" or
        // path == "ceylon/language/1.2.0/ceylon.language-1.2.0.js"
        value parts = path.split('/'.equals).sequence();
        
        value fileName = parts.last else "";
        
        if (parts.size == 1) {
            // parts == [ceylon.language-1.2.0.js]
            value suffix = getSuffixFromFilename(fileName);
            value p = fileName.firstInclusion("-");
            if (exists p) {
                value name = fileName[0..p-1];
                value version = fileName[p+1..fileName.size-suffix.size-1];
                return ArtifactContext(namespace, name, version, suffix);
            }
        } else if (parts.size >= 3) {
            // parts == [ceylon, language, 1.2.0, ceylon.language-1.2.0.js]
            value name = ".".join(parts[0..parts.size-3]);
            // name == "ceylon.language"
            value version = parts[parts.size - 2] else "";
            value suffix = getSuffixFromFilename(parts.last);
            if (fileName == name + "-" + version + suffix) {
                return ArtifactContext(namespace, name, version, suffix);
            }
        }
    } catch (Exception ex) { }
    return null;
}

String? findArtifactPath(RepositoryManager manager,
    ArtifactContext context) {
    
    if (exists artifact = manager.getArtifact(context),
            artifact.\iexists(),
            artifact.file) {
        return artifact.absolutePath;
    }
    
    return null;
}